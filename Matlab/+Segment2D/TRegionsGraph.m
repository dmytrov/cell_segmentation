classdef TRegionsGraph < handle
    properties (GetAccess = public, SetAccess = protected)
    end
    
    properties (Access = protected)
        pStack;         % ImageUtils.TImageStack        
        lRegions;       % Segment2D.TRegion
        lLinks;         % Segment2D.TLink
        LikelihoodFunction; % likelihood provider
   end
    
    methods (Access = public)
        function this = TRegionsGraph(stack, likelihoodFunction)
            this.pStack = stack;           
            this.LikelihoodFunction = likelihoodFunction;                
            [sx, sy, sz] = size(this.pStack.Data);

            % Construct the full grid of regions
            aRegions = Segment2D.TRegion.empty;
            aRegions(sx, sy) = Segment2D.TRegion();                        
            for k1 = 1:sx
                for k2 = 1:sy
                    aRegions(k1, k2) = Segment2D.TRegion(this.pStack, this.LikelihoodFunction, [k1, k2]');
                end
            end
            
            % Link the regions into a grid
            this.lLinks = Segment2D.TLink.empty;
            this.lLinks(2*sx*sy - sx - sy) = Segment2D.TLink();
            k = 1;
            for k1 = 1:sx-1
                for k2 = 1:sy-1
                    this.lLinks(k) = Segment2D.TLink(this.LikelihoodFunction, aRegions(k1, k2), aRegions(k1+1, k2));
                    k = k + 1;
                    this.lLinks(k) = Segment2D.TLink(this.LikelihoodFunction, aRegions(k1, k2), aRegions(k1, k2+1));
                    k = k + 1;                    
                end
            end
            for k1 = 1:sx-1
                this.lLinks(k) = Segment2D.TLink(this.LikelihoodFunction, aRegions(k1, sy), aRegions(k1+1, sy));
                k = k + 1;                    
            end
            for k1 = 1:sy-1
                this.lLinks(k) = Segment2D.TLink(this.LikelihoodFunction, aRegions(sx, k2), aRegions(sx, k2+1));
                k = k + 1;                    
            end
                        
            this.lRegions = aRegions(:);
        end
        
        function res = DoClustering(this)
            bFinished = 0;
            [sx, sy, sz] = size(this.pStack.Data);
            res = nan(sx, sy, 1);
            kIter = 1;
            while (~bFinished)
                [nRegions, res(:,:, kIter)] = this.BuildMap();
                fprintf('Regions: %d\n', nRegions);
                
                logLikelihoodRegions = nan(size(this.lLinks));
                logLikelihoodGain = nan(size(this.lLinks));
                k = 1;
                for link = this.lLinks
                    reg1 = link.Regions(1);
                    reg2 = link.Regions(2);
                    logLikelihoodRegions(k) = log(reg1.Likelihood) + log(reg2.Likelihood);
                    %logLikelihoodRegions(k) = log(link.Regions(1).Likelihood) + log(link.Regions(2).Likelihood);
                    logLikelihoodGain(k) = log(link.Likelihood) - 0.5 * logLikelihoodRegions(k);
                    k = k + 1;
                end
                [maxGain, kMax] = max(logLikelihoodGain);
                if (maxGain > 0)
                    % Merge this.lLinks(kMax) linked regions
                    regionsToMerge = this.lLinks(kMax).Regions;
                    regionMerged = Segment2D.TRegion(this.pStack, this.LikelihoodFunction, ...
                        [regionsToMerge(1).CorrMatrix.Pixels, regionsToMerge(2).CorrMatrix.Pixels]);
                    kLinks1 = this.FindLinksNumbersToRegion(regionsToMerge(1));
                    %kLinks1(kMax) = 0;
                    kLinks2 = this.FindLinksNumbersToRegion(regionsToMerge(2));
                    %kLinks2(kMax) = 0;
                    kLinks = kLinks1 | kLinks2;
                    kNeighbRegions = this.FindRegionsNumbersFromLinks(this.lLinks(kLinks));
                    kNeighbRegions(this.lRegions == regionsToMerge(1)) = 0;
                    kNeighbRegions(this.lRegions == regionsToMerge(2)) = 0;
                    neighbRegions = this.lRegions(logical(kNeighbRegions));
                    % Remove links and regions
                    this.lLinks = this.lLinks(~kLinks);
                    this.lRegions = this.lRegions(this.lRegions ~= regionsToMerge(1));
                    this.lRegions = this.lRegions(this.lRegions ~= regionsToMerge(2));
                    % Add new links and regions
                    this.lRegions = [this.lRegions; regionMerged];
                    for kRegion = neighbRegions'
                        newLink = Segment2D.TLink(this.LikelihoodFunction, kRegion, regionMerged);
                        this.lLinks = [this.lLinks, newLink];
                    end
                else
                    bFinished = 1;
                end
                kIter = kIter + 1;
            end
        end
        
        function [nRegions, regMap] = BuildMap(this)
            nRegions = size(this.lRegions, 1);
            [sx, sy, sz] = size(this.pStack.Data);
            regMap = nan(sx, sy);
            k = 1;
            for region = this.lRegions'
                corrMatrix = region.CorrMatrix;     % Matlab can't parse "region.CorrMatrix.Pixels"
                for pixel = corrMatrix.Pixels       
                    regMap(pixel(1), pixel(2)) = k;
                end
                k = k + 1;
            end
        end
    end    
    
    methods (Access = protected)
        function res = FindLinksNumbersToRegion(this, region)
            res = zeros(size(this.lLinks));
            k = 1;
            for link = this.lLinks
                if ((link.Regions(1) == region) || (link.Regions(2) == region))
                    res(k) = 1;
                end
                k = k + 1;
            end
        end
        
        function res = FindRegionsNumbersFromLinks(this, lLinks)
            res = zeros(size(this.lRegions));
            for link = lLinks
                res = res | (this.lRegions == link.Regions(1));
                res = res | (this.lRegions == link.Regions(2));
            end
        end
    end
end










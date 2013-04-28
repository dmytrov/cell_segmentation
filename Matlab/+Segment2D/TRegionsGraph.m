classdef TRegionsGraph < handle
    properties (GetAccess = public, SetAccess = protected)
    end
    
    properties (Access = protected)
        pStack;         % ImageUtils.TImageStack        
        lRegions;       % Segment2D.TRegion
        nLinks;         % number of links
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
            this.nLinks = 0;
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
            for k2 = 1:sy-1
                this.lLinks(k) = Segment2D.TLink(this.LikelihoodFunction, aRegions(sx, k2), aRegions(sx, k2+1));
                k = k + 1;                    
            end
                        
            this.lRegions = aRegions(:)';
        end
        
        function res = DoClustering(this)
            bFinished = 0;
            [sx, sy, sz] = size(this.pStack.Data);
            res = nan(sx, sy, 1);
            kIter = 1;
            while (~bFinished)
                %[nRegions, res(:,:, kIter)] = this.BuildMap();
                fprintf('Regions: %d\n', length(this.lRegions));
                
                likelihoodLink = nan(size(this.lLinks));
                k = 1;
                for link = this.lLinks
                    likelihoodLink(k) = link.Likelihood;
                    k = k + 1;
                end
                [maxGain, kMax] = max(likelihoodLink);
                if (maxGain > 1e-9)
                    linkToMerge = this.lLinks(kMax);
                    regionToMerge1 = linkToMerge.Region1;
                    regionToMerge2 = linkToMerge.Region2;
                    regionMerged = Segment2D.TRegion(this.pStack, this.LikelihoodFunction, ...
                        [regionToMerge1.CorrMatrix.Pixels, regionToMerge2.CorrMatrix.Pixels]);
                    links12 = unique([regionToMerge1.Links, regionToMerge2.Links]);
                    neighbRegions = [];
                    for link = links12
                        neighbRegions = [neighbRegions, link.Region1, link.Region2];
                    end
                    neighbRegions = unique(neighbRegions);
                    neighbRegions = setdiff(neighbRegions, [regionToMerge1, regionToMerge2]);
                    % Remove links and regions
                    for link = links12
                        link.Unlink();
                    end
                    this.lLinks = setdiff(this.lLinks, links12);
                    this.lRegions = setdiff(this.lRegions, [regionToMerge1, regionToMerge2]);
                    % Add new links and regions
                    this.lRegions = [this.lRegions, regionMerged];
                    for kRegion = neighbRegions
                        newLink = Segment2D.TLink(this.LikelihoodFunction, kRegion, regionMerged);
                        this.lLinks = [this.lLinks, newLink];
                    end
                else
                    bFinished = 1;
                end
                kIter = kIter + 1;
            end
        end
        
        function AddLink(this, link)
            
        end
        
        function DeleteLink(this, link)
        end
        
        function [nRegions, regMap] = BuildMap(this)
            nRegions = size(this.lRegions, 2);
            [sx, sy, sz] = size(this.pStack.Data);
            regMap = nan(sx, sy);
            k = 1;
            for region = this.lRegions
                corrMatrix = region.CorrMatrix;     % Matlab can't parse "region.CorrMatrix.Pixels"
                for pixel = corrMatrix.Pixels       
                    regMap(pixel(1), pixel(2)) = k;
                end
                k = k + 1;
            end
        end
        
        function res = GetRegions(this)
            res = this.lRegions;
        end
    end    
    
    methods (Access = protected)
        function res = FindLinksNumbersToRegion(this, region)
            res = zeros(size(this.lLinks));
            k = 1;
            for link = this.lLinks
                if ((link.Region1 == region) || (link.Region2 == region))
                    res(k) = 1;
                end
                k = k + 1;
            end
        end
        
        function res = FindRegionsNumbersFromLinks(this, lLinks)
            res = zeros(size(this.lRegions));
            for link = lLinks
                res = res | (this.lRegions == link.Region1);
                res = res | (this.lRegions == link.Region2);
            end
        end
        
        function res = FindRegionsFromLinks(this, lLinks)
            res = [];
            for link = lLinks
                res = [res, link.Region1, link.Region2];
            end
        end
    end
end










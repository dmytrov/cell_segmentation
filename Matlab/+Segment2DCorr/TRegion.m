classdef TRegion < handle
    properties (GetAccess = public, SetAccess = protected)
        Links;          % list of links the region is connected to
        CorrMatrix;     % MathUtils.TCorrMatrix
        Likelihood;     % Likelihood the region is a cell        
        LikelihoodFunction; % likelihood provider
    end
    
    methods (Access = public)
        function this = TRegion(stack, likelihoodFunction, pixels, links)
            if (nargin == 3)
                this.LikelihoodFunction = likelihoodFunction;
                this.CorrMatrix = MathUtils.TCorrMatrix(stack, pixels);
                this.Likelihood = this.LikelihoodFunction.CalcLikelihood(this.CorrMatrix);
                this.Links = [];
            elseif (nargin == 4)
                this.Links = links;
            end
        end
        
        function SetLinks(this, links)
            this.Links = links;
        end
        
        function AddLinks(this, links)
            this.Links = [this.Links, links];
        end
        
        function RemoveLinks(this, links)
            for link = links
                this.Links = this.Links(this.Links ~= link);
            end
        end
    end
    
end
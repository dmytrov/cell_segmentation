classdef TLink < handle
    properties (GetAccess = public, SetAccess = protected)
        Region1;            % neighbouring regions
        Region2;            % neighbouring regions
        CorrMatrix;         % MathUtils.TCorrMatrix crosscorr of the linked regions
        Likelihood;         % Likelihood the full region is a cell        
        LikelihoodFunction; % likelihood provider
    end
    
    methods (Access = public)
        function this = TLink(likelihoodFunction, region1, region2)
            if (nargin == 3)
                this.LikelihoodFunction = likelihoodFunction;
                this.Region1 = region1;
                this.Region2 = region2;
                this.CorrMatrix = MathUtils.TCorrMatrix.CombineMatrices( ...
                    region1.CorrMatrix, ...
                    region2.CorrMatrix);
                this.Likelihood = this.LikelihoodFunction.CalcLikelihood(this.CorrMatrix);
                this.Region1.AddLinks(this);
                this.Region2.AddLinks(this);
            end
        end
        
        function Unlink(this)
            this.Region1.RemoveLinks(this);
            this.Region2.RemoveLinks(this);
        end
    end
    
end
classdef TLink < handle
    properties (GetAccess = public, SetAccess = protected)
        Regions;            % neighbouring regions
        CorrMatrix;         % MathUtils.TCorrMatrix crosscorr of the linked regions
        Likelihood;         % Likelihood the full region is a cell        
        LikelihoodFunction; % likelihood provider
    end
    
    methods (Access = public)
        function this = TLink(likelihoodFunction, region1, region2)
            if (nargin == 3)
                this.LikelihoodFunction = likelihoodFunction;
                this.Regions = [region1, region2];
                this.CorrMatrix = MathUtils.TCorrMatrix.CombineMatrices( ...
                    region1.CorrMatrix, ...
                    region2.CorrMatrix);
                this.Likelihood = this.LikelihoodFunction.CalcLikelihood(this.CorrMatrix);
            end
        end
    end
    
    methods (Access = protected)
    end
    
end
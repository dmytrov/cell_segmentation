classdef TRegion < handle
    properties (GetAccess = public, SetAccess = protected)
        CorrMatrix;     % MathUtils.TCorrMatrix
        Likelihood;     % Likelihood the region is a cell        
        LikelihoodFunction; % likelihood provider
    end
    
    methods (Access = public)
        function this = TRegion(stack, likelihoodFunction, pixels)
            if (nargin == 3)
                this.LikelihoodFunction = likelihoodFunction;
                this.CorrMatrix = MathUtils.TCorrMatrix(stack, pixels);
                this.Likelihood = this.LikelihoodFunction.CalcLikelihood(this.CorrMatrix);
            end
        end
                
    end
    
    methods (Access = protected)
    end
end
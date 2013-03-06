classdef TRegionLikelihood < handle
    properties (Access = protected)
        % Priors
        EllipsicityPrior;   % region ellipsicity of PCA axes
        SizePrior;          % area prior
        CorrelationPrior;   % account for all pixels cross-correlations
    end
    
    methods (Access = public)
        function this = TRegionLikelihood(settings)
            % Priors
            this.EllipsicityPrior = Bayesian.TGaussianPrior(1, 2);
            this.SizePrior = Bayesian.TGaussianPrior(10, 5);
            this.CorrelationPrior = Bayesian.TGaussianPrior(1, 1);   % account for all pixels cross-correlations            
        end
        
        function res = CalcLikelihood(this, corrMatrix)
            nPixels = size(corrMatrix.Pixels, 2);
            [vAxes, scale] = MathUtils.GetPrincipalAxes(corrMatrix.Pixels);
            scale = scale + 0.5 * sqrt(2);
            ellipsicity = max(scale) / min(scale);
            %for 
            res = (sum(corrMatrix.CorrMatrix(:)) - nPixels) / nPixels;
            if (nPixels > 25)
                res = 0;
            end
            res = res + 1e-6;
        end
    end
end
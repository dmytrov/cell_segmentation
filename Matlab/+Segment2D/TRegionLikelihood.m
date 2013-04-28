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
            this.EllipsicityPrior = Bayesian.TGaussianPrior(1, 1);
            this.SizePrior = Bayesian.TGaussianPrior(20, 5);
            this.CorrelationPrior = Bayesian.TGaussianPrior(1, 1);   % account for all pixels cross-correlations            
        end
        
        function res = CalcLikelihood(this, corrMatrix)
            nPixels = size(corrMatrix.Pixels, 2);
            [vAxes, scale] = MathUtils.GetPrincipalAxes(corrMatrix.Pixels);
            scale = scale + 0.5 * sqrt(2);
            ellipsicity = max(scale) / min(scale);
            meanCorr = (sum(corrMatrix.CorrMatrix(:)) - nPixels) / (nPixels^2 - nPixels);            
            minCorr = min(corrMatrix.CorrMatrix(:));
            if (minCorr <= 0.2)
                res = 1e-9;
                return;
            end
            res = this.EllipsicityPrior.ValueAt(ellipsicity) * ...
                  this.CorrelationPrior.ValueAt(meanCorr) * ...
                  this.SizePrior.ValueAt(nPixels) +  ...
                  1e-9;
        end
    end
end
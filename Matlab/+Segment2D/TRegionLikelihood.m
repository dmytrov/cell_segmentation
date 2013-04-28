classdef TRegionLikelihood < handle
    properties (Access = protected)
        % Priors
        EllipsicityPrior;   % region ellipsicity of PCA axes
        SizePrior;          % area prior
        CorrelationMin;     % min correlation cutoff
        CorrelationPrior;   % account for all pixels cross-correlations
        CorrelationStabilityPrior;   % account for all pixels cross-correlations stability
    end
    
    methods (Access = public)
        function this = TRegionLikelihood(settings)
            this.CorrelationMin = 0.2;
            % Priors            
            this.EllipsicityPrior = Bayesian.TGaussianPrior(1, 0.05);
            this.SizePrior = Bayesian.TGaussianPrior(20, 5);
            this.CorrelationPrior = Bayesian.TGaussianPrior(1, 1);   
            this.CorrelationStabilityPrior = Bayesian.TGaussianPrior(0, 0.01);
        end
        
        function res = CalcLikelihood(this, corrMatrix)
            nPixels = size(corrMatrix.Pixels, 2);
            [vAxes, scale] = MathUtils.GetPrincipalAxes(corrMatrix.Pixels);
            scale = scale + 0.5 * sqrt(2);
            ellipsicity = max(scale) / min(scale);
            sizeFactor = min(this.SizePrior.mean, nPixels) / this.SizePrior.mean;
            ellipsicity = 1*(1-sizeFactor) + ellipsicity*(sizeFactor);
            meanCorr = (sum(corrMatrix.CorrMatrix(:)) - nPixels) / (nPixels^2 - nPixels);            
            minCorr = min(corrMatrix.CorrMatrix(:));
            mUpper = triu(corrMatrix.CorrMatrix);
            mUpper = mUpper(mUpper ~= 0);
            mUpperMean = mean(mUpper);
            mUpper = mUpper - mUpperMean;
            varCorr = (mUpper' * mUpper) / length(mUpper);
            if (minCorr <= this.CorrelationMin)
                res = 1e-9;
                return;
            end
            res = this.EllipsicityPrior.ValueAt(ellipsicity) * ...
                  this.CorrelationPrior.ValueAt(meanCorr) * ...
                  this.CorrelationStabilityPrior.ValueAt(varCorr) * ...
                  this.SizePrior.ValueAt(nPixels) +  ...
                  1e-9;
        end
    end
end
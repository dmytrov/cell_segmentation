classdef TGaussianPrior < Bayesian.TPrior
    properties (Access = public)
        mean;
        variance;
    end
    
    methods (Access = public)
        function obj = TGaussianPrior(mean, variance)
            obj = obj@Bayesian.TPrior();
            obj.mean = mean;
            obj.variance = variance;
        end
                
        function res = ValueAt(obj, x)
            res = normpdf(x, obj.mean, obj.variance);
        end
    end
end
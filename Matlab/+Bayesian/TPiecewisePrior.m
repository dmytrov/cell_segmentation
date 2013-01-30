% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef TPiecewisePrior < Bayesian.TPrior
    properties (Access = public)
       knots;
       values;
       interpolationMethod;
    end
    
    methods (Access = public)
        function obj = TPiecewisePrior()
            obj = obj@Bayesian.TPrior();
            obj.knots = [];
            obj.values = [];
            obj.interpolationMethod = 'cubic';
        end
        
        function AddControlPointAndNormalize(obj, knots, values)
            obj.AddControlPoint(knots, values);
            obj.Normalize();            
        end
        
        function AddControlPoint(obj, knots, values)
            obj.knots  = [obj.knots, knots(:)'];
            obj.values = [obj.values, values(:)'];
            % Maintain the sorted order
            [obj.knots, indexes] = sort(obj.knots);
            obj.values = obj.values(indexes);
        end
        
        function Normalize(obj)
            obj.values = obj.values / norm(obj.values);
        end
        
        function res = ValueAt(obj, x)
            if (numel(obj.knots) <= 1)
                res = ones(size(x)); % uniform (no preference)
            else
                res = interp1(obj.knots, obj.values, x, obj.interpolationMethod);
            end
            res((x < obj.knots(1)) | (x > obj.knots(end))) = 0; % zeros outsize of the knots range
        end
    end
end
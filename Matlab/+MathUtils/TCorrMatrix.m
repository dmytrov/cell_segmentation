classdef TCorrMatrix < handle
    properties (GetAccess = public, SetAccess = protected)
        Stack;          % ImageUtils.TImageStack
        Pixels;         % 2xN list pf pixels coordinates
        CorrMatrix;     % the actual correlation matrix
    end
    
    methods (Access = public)
        function this = TCorrMatrix(stackCentered, lPixels)
            if (nargin < 2)
                lPixels = [];
            end
            this.Stack = stackCentered;
            this.Pixels = lPixels;
            this.UpdateCorrelationMatrix();
        end
        
        function SetPixels(this, lPixels)
            this.Pixels = lPixels;
            this.UpdateCorrelationMatrix();
        end
    end
    
    methods (Static)    
        function res = CombineMatrices(m1, m2)
            if (m1.Stack == m2.Stack)
                res = MathUtils.TCorrMatrix(m1.Stack);
                res.Pixels = [m1.Pixels, m2.Pixels];
                s1 = size(m1.Pixels, 2);
                s2 = size(m2.Pixels, 2);
                res.CorrMatrix(s1+1:s1+s2, s1+1:s1+s2) = m2.CorrMatrix;
                res.CorrMatrix(1:s1, 1:s1) = m1.CorrMatrix;                
                crossCorr = MathUtils.TCorrMatrix.CalcCrossCorrMatrix(res.Stack, m1.Pixels, m2.Pixels);
                res.CorrMatrix(s1+1:s1+s2, 1:s1) = crossCorr';
                res.CorrMatrix(1:s1, s1+1:s1+s2) = crossCorr;
            end
        end
        
        function res = CalcCrossCorrMatrix(stack, pixels1, pixels2)
            res = [];
            if (~isempty(pixels1) && ~isempty(pixels2))
                [sx, sy, sz] = size(stack.Data);                
                data1 = nan(sz, size(pixels1, 2));
                data2 = nan(sz, size(pixels2, 2));
                for k = 1:size(pixels1, 2)
                    data1(:, k) = stack.Data(pixels1(1, k), pixels1(2, k), :);
                end
                for k = 1:size(pixels2, 2)
                    data2(:, k) = stack.Data(pixels2(1, k), pixels2(2, k), :);
                end
                autoVarianceSqrt1 = sqrt(sum(data1 .* data1, 1));
                autoVarianceSqrt2 = sqrt(sum(data2 .* data2, 1));
                res = (data1' * data2) ./ (autoVarianceSqrt1' * autoVarianceSqrt2);
            end
        end
        
        function res = CalcCorrMatrix(stack, pixels)
            res = [];
            if (~isempty(pixels))
                [sx, sy, sz] = size(stack.Data);                
                data = nan(sz, size(pixels, 2));
                for k = 1:size(pixels, 2)
                    data(:, k) = stack.Data(pixels(1, k), pixels(2, k), :);
                end
                autoVarianceSqrt = sqrt(sum(data .* data, 1));
                res = (data' * data) ./ (autoVarianceSqrt' * autoVarianceSqrt);
            end
        end
    end
    
    methods (Access = protected)
        function UpdateCorrelationMatrix(this)
            this.CorrMatrix = MathUtils.TCorrMatrix.CalcCorrMatrix(this.Stack, this.Pixels);
        end
    end
end





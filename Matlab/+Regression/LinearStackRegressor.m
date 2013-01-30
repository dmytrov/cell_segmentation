% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef LinearStackRegressor < Regression.StackRegressor
    properties (Access = private)
        x;
        y;
        z;
    end
    
    methods (Access = public)
        function obj = LinearStackRegressor(stack, settings)
            obj = obj@Regression.StackRegressor(stack);
            [obj.x, obj.y, obj.z] = meshgrid(1:size(stack, 1), 1:size(stack, 2), 1:size(stack, 3));
            obj.x = obj.x * settings.Resolution(1); % * settings.InvAnisotropy(1);
            obj.y = obj.y * settings.Resolution(2); % * settings.InvAnisotropy(2);
            obj.z = obj.z * settings.Resolution(3); % * settings.InvAnisotropy(3);
        end
                
        function res = Value(obj, pt)
            % Strange matlab indexing order:
            res = interp3(obj.x, obj.y, obj.z, obj.stack, pt(2,:), pt(1,:), pt(3,:), 'linear'); 
        end
    end
end
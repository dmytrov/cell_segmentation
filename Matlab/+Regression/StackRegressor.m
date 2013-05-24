% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef StackRegressor < handle
    properties (SetAccess = protected)
        stack;
    end
    
    methods (Access = public)
        function obj = StackRegressor(stack)
            obj.stack = stack; 
        end

        function res = Value(obj, pt)
	   % dummy function for compatibility with old matlab versions
	   res = 0;
	end
    end    
end
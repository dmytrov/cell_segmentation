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
    end
    
    methods (Abstract)
        res = Value(obj, pt)
    end    
end
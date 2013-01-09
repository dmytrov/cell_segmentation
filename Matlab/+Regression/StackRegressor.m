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
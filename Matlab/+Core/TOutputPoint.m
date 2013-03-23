classdef TOutputPoint < Core.TConnectionPoint
    properties (Access = public)
        Others;
    end
    
    methods (Access = public)
        function this = TOutputPoint(name, type, component)
            this = this@Core.TConnectionPoint(name, type, component);
        end
    end
end
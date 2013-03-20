classdef TConnectionPoint < handle
    properties (Access = public)
        Name;
        Type;
    end
    
    properties (GetAccess = public, SetAccess = protected)
        Component;
        Other;
    end
    
    methods (Access = public)
        function this = TConnectionPoint(name, type, component)
            this.Name = name;
            this.Type = type;
            this.Component = component;            
            this.Other = [];
        end                
    end
end
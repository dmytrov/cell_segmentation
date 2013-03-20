classdef TComponent < handle
    properties (Constant = true)
        VALID       = 0;
        INVALID     = 1;
        RUNNING     = 2;
    end
    
    properties (GetAccess = public, SetAccess = public)
        State;
    end
    
    properties (GetAccess = public, SetAccess = private)
        Name;
        Inputs;
        Outputs;        
        Callbacks;
    end
    
    methods (Access = public)
        function this = TComponent(name)
            this.Name = name;
            this.State = Code.TComponemt.INVALID;
            this.Inputs = Core.TInputPoint.empty;
            this.Outputs = Core.TOutputPoint.empty;
        end
    end
    
    
end

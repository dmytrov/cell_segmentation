classdef TDataContainer < Core.TComponent
    properties (Access = public)
        Data;
    end
    
    methods (Access = public)        
        function this = TDataContainer(name)
            this = this@Core.TComponent(name);
            this.Inputs = [Core.TInputPoint('In', '', this)];
            this.Outputs = [Core.TOutputPoint('Out', '', this)];
        end
        
        function OnInputConnected(this)
            % Propagate the type
            this.Outputs(1).Type = this.Inputs(1).Type;
        end
        
        function Run(this)
            % Nothing to do here, it is just a passive data container
        end
    end
end
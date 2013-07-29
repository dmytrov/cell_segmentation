classdef TDataContainer < Core.TComponent
    properties (Access = public)
        Data;
    end
    
    methods (Access = public)        
        function this = TDataContainer(name, pipeline)
            this = this@Core.TComponent(name, pipeline);
            this.Inputs = [Core.TInputPoint('In', '', this)];
            this.Outputs = [Core.TOutputPoint('Out', '', this)];
        end
        
        function OnInputConnected(this)
            % Propagate the type
            this.Outputs(1).Type = this.Inputs(1).Type;
        end
        
        function OnStateChanged(this)            
            if (this.State == Core.TComponentState.INVALID)
                % Clear the invalid data
                this.Data = [];
            end
        end
        
        function Run(this)
            % Nothing to do here, it is just a passive data container
        end
    end
end
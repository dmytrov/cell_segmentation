classdef TComponent < handle
    
    properties (GetAccess = public, SetAccess = public)
        State;
    end
    
    properties (GetAccess = public, SetAccess = protected)
        Name;
        Inputs;
        Outputs;        
        Callbacks;
    end
    
    methods (Access = public)
        function this = TComponent(name)
            this.Name = name;
            this.State = Core.TComponentState.INVALID;
            this.Inputs = Core.TInputPoint.empty;
            this.Outputs = Core.TOutputPoint.empty;
        end
        
        function res = InputByName(this, name)
            for input = this.Inputs
                if (strcmp(input.Name, name))
                    res = input;
                    return;
                end
            end
            throw(MException('TComponent:InputByName', ['Input "', name, '" is not foud']));            
        end
        
        function res = OutputByName(this, name)
            for output = this.Outputs
                if (strcmp(output.Name, name))
                    res = output;
                    return;
                end
            end
            throw(MException('TComponent:OutputByName', ['Output "', name, '" is not foud']));            
        end
        
        function ConnectInputsTo(this, component)
            if ((numel(this.Inputs) ~= 1) || (numel(component.Outputs) ~= 1))
                throw(MException('TComponent:ConnectInputsTo', ['Number of outputs and inputs must be 1 for automatic connection']));            
            end
            this.Inputs(1).ConnectTo(component.Outputs(1))
        end
        
        % Prototype
        function OnInputConnected(this)            
        end
        
        % Prototype of main method
        function Run(this)
            exception = MException('TComponent:Run', 'Not implemented');
            throw(exception);
        end
    end
        
    
end
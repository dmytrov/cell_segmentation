classdef TComponent < handle
    
    properties (GetAccess = public, SetAccess = public)
        State;
    end
    
    properties (GetAccess = public, SetAccess = protected)
        Name;
        Pipeline;
        Inputs;
        Outputs;        
        Callbacks;
    end
    
    properties (Access = protected)
        ExternalUI;
    end
    
    methods
        function set.State(this, value)
            this.State = value;
            this.OnStateChanged();
        end
    end
    
    methods (Access = public)
        function this = TComponent(name, pipeline)
            this.Name = name;
            this.Pipeline = pipeline;
            this.State = Core.TComponentState.INVALID;
            this.Inputs = Core.TInputPoint.empty;
            this.Outputs = Core.TOutputPoint.empty;
        end        
        
        function OnStateChanged(this)
            % Empty
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
        
        function res = HasChildren(this)
            res = false;
            for output = this.Outputs
                if (~isempty(output.Others))
                    res = true;
                    return;
                end
            end
        end
        
        function res = GetUIClass(this)
            res = class(this);
        end
        
        % Prototype
        function OnInputConnected(this)            
        end
        
        % Prototype of main method
        function Run(this)
            exception = MException('TComponent:Run', 'Not implemented');
            throw(exception);
        end
        
        % Prototype
        function GetParameters(this, params)
        end
        
        % Prototype
        function SetParameters(this, params)
        end
        
        % Prototype
        function SetNativeUIVisible(this, visible)
        end
        
        % Prototype
        function BindJavaUI(this, ui)
            this.ExternalUI = ui;
        end
        
        % Prototype
        function res = UnbindUI(this)
            res = {this.ExternalUI};
            this.ExternalUI = [];
        end
        
        % Prototype
        function res = BindUI(this, callBacks)
            this.ExternalUI = callBacks{1};
            res = callBacks(2:end);
        end
        
    end
        
    
end

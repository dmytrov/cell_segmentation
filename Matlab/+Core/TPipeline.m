classdef TPipeline < handle
    properties (Access = public)
        Name;
        Components;
        OnComponentsStateChangeCallback;
        MessageLog;
    end
    
    methods (Access = protected)
        function res = DataContainerName(this, output)
            res = [output.Component.Name,'->', output.Name, ''];
        end
    end
    
    methods (Access = public)
        function this = TPipeline(name)
            this.Name = name;
            this.Components = cell(0, 1);
            this.MessageLog = Core.TMessageLog();
            this.MessageLog.PrintToConsole = true;
        end
        
        function AddComponent(this, component)
            if (isempty(this.ComponentByName(component.Name)))
                this.Components = [this.Components; {component}];
            end
        end
        
        function AddProcessorsChain(this, processors)
            procPrev = processors{1};
            this.AddComponent(procPrev);
            for kProcessor = 2:numel(processors)
                processor = processors{kProcessor};
                dataContainer = Core.TDataContainer(this.DataContainerName(procPrev.Outputs(1)), this);
                this.AddComponent(dataContainer);
                dataContainer.ConnectInputsTo(procPrev);
                this.AddComponent(processor);
                processor.ConnectInputsTo(dataContainer);
                procPrev = processor;
            end
        end
        
        function ConnectPoints(this, input, output)
            if (~isa (input, 'Core.TInputPoint'))
                throw(MException('TPipeline:ConnectPoints', 'Argument "input" is not a Core.TInputPoint object'));
            end
            if (~isa (output, 'Core.TOutputPoint'))
                throw(MException('TPipeline:ConnectPoints', 'Argument "output" is not a Core.TOutputPoint object'));
            end
            if (and(isa(input.Component, 'TDataContainer'), isa(output.Component, 'TDataContainer')))
                throw(MException('TPipeline:ConnectPoints', 'Can not connect two data containers'));
            end
            if (xor(isa(input.Component, 'TDataContainer'), isa(output.Component, 'TDataContainer')))
                input.ConnectTo(output);
            else % two processors
                if (isempty(output.Others))
                    dataContainer = Core.TDataContainer(this.DataContainerName(output), this);
                    dataContainer.ConnectInputsTo(output.Component);                    
                    this.AddComponent(dataContainer);
                else
                    dataContainer = output.Others.Component;
                end
                input.ConnectTo(dataContainer.Outputs(1));
            end            
        end
        
        function res = ComponentByName(this, name)
            res = [];
            for k = this.Components'
                component = k{1};
                if (strcmp(component.Name, name))
                    res = component;
                    return;
                end
            end
        end
        
        function CallComponentsStateChangeCallback(this)
            if (~isempty(this.OnComponentsStateChangeCallback))
                this.OnComponentsStateChangeCallback();
            end
        end
        
        function Run(this, component, force)
            if (nargin < 3)
                force = false;
            end
            if (~isa (component, 'Core.TComponent'))
                exception = MException('TPipeline:Run', 'Argument is not a Core.TComponent object');
                throw(exception);
            end
            
            if (force || (component.State ~= Core.TComponentState.VALID))
                this.RunParents(component);
                this.MarkChildrenInvalid(component);
                component.State = Core.TComponentState.RUNNING;
                this.CallComponentsStateChangeCallback();
                this.MessageLog.PrintLine(['Running component "', component.Name, '"...']);
                component.Run();
                component.State = Core.TComponentState.VALID;
                this.MessageLog.PrintLine(['Running component "', component.Name, '" has finished']);
                this.CallComponentsStateChangeCallback();
            end
        end
        
        function RunParents(this, component)
            for input = component.Inputs
                this.Run(input.Other.Component);
            end
        end
        
        function RunAll(this)
            for component = this.Components'            
                if (~component{1}.HasChildren())
                    this.Run(component{1});
                end
            end
        end
        
        function MarkChildrenInvalid(this, component)
            for output = component.Outputs
                for input = output.Others
                    if (input.Component.State ~= Core.TComponentState.INVALID)
                        input.Component.State = Core.TComponentState.INVALID;
                        this.MarkChildrenInvalid(input.Component);
                    end
                end
            end
        end
    end
end
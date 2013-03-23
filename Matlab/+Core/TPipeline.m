classdef TPipeline < handle
    properties (Access = public)
        Name;
        Components;
    end
    
    methods (Access = public)
        function this = TPipeline(name)
            this.Name = name;
            this.Components = Core.TComponent.empty;
        end
        
        function AddComponent(this, component)
            this.Components = [this.Components, component];
        end
        
        function AddProcessorsChain(this, processors)
            procPrev = processors{1};
            this.AddComponent(procPrev);
            for kProcessor = 2:numel(processors)
                processor = processors{kProcessor};
                dataContainer = Core.TDataContainer([procPrev.Name, ' data']);
                this.AddComponent(dataContainer);
                dataContainer.ConnectInputsTo(procPrev);
                this.AddComponent(processor);
                processor.ConnectInputsTo(dataContainer);
                procPrev = processor;
            end
        end
        
        function Run(this, component)
            if (~isa (component, 'Core.TComponent'))
                exception = MException('TPipeline:Run', 'Argument is not a Core.TComponent object');
                throw(exception);
            end
            
            if (component.State ~= Core.TComponentState.VALID)
                this.RunParents(component);
                this.MarkChildrenInvalid(component);
                component.State = Core.TComponentState.RUNNING;
                component.Run();
                component.State = Core.TComponentState.VALID;
            end
        end
        
        function RunParents(this, component)
            for input = component.Inputs
                this.Run(input.Other.Component);
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
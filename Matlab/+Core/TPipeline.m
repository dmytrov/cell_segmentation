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
        
        function Run(this, component)
            if (~isa (component, Core.TComponent))
                exception = MException('TPipeline.Run', 'Argument is not a Core.TComponent object');
                throw(exception);
            end
            
            if (component.State ~= Core.TComponent.VALID)
                this.RunParents(component);
                this.MarkChildrenInvalid(component);
                component.State = Core.TComponent.RUNNING;
                component.Run();
                component.State = Core.TComponent.VALID;
            end
        end
        
        function this.RunParents(this, component)
            for input = component.Inputs
                this.Run(input.Other.Component);
            end
        end
        
        function MarkChildrenInvalid(this, component)
            for output = component.Outputs
                for input = output.Others
                    if (input.Component.State ~= Core.TComponent.INVALID)
                        input.Component.State = Core.TComponent.INVALID;
                        this.MarkChildrenInvalid(input.Component);
                    end
                end
            end
        end
    end
end
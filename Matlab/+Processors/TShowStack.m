classdef TShowStack < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
    end
    
    properties (Access = public)
        Visualiser;        
    end
    
    methods (Access = public)
        function this = TShowStack(name)
            this = this@Core.TProcessor(name);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
            this.Outputs = [];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);
            if (~isempty(this.Visualiser))
                close(this.Visualiser.h);
                this.Visualiser = [];
            end
        end
        
        function SetNativeUIVisible(this, visible)
            if (visible)
                if (isempty(this.Visualiser))
                    this.Visualiser = UI.StackViewer(this.Inputs(this.IN_STACK).PullData());
                    this.Visualiser.deleteOnClose = 0;
                else
                    set(this.Visualiser.h, 'Visible', 'on');                    
                end
            else
                if (~isempty(this.Visualiser))
                    set(this.Visualiser.h, 'Visible', 'off');
                end
            end
        end
    end    
end
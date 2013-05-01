classdef TShowStackAndModelsSectionsInMatlab < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        IN_MODELS = 2;
    end
    
    properties (Access = public)
        Settings;
        Visualiser;        
    end
    
    methods (Access = public)
        function this = TShowStackAndModelsSectionsInMatlab(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this), ...
                           Core.TInputPoint('Models', 'WEMesh List', this)];
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
                    stack = this.Inputs(this.IN_STACK).PullData();
                    models = this.Inputs(this.IN_MODELS).PullData();
                    this.Visualiser = UI.StackModelSliceViewer(stack);
                    this.Visualiser.settings = this.Settings;
                    this.Visualiser.SetModels(models);
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
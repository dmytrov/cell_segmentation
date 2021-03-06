classdef TShowModelsInMatlab < Core.TProcessor
    properties (Constant = true)
        IN_MODELS = 1;
    end
    
    properties (Access = public)
        Visualiser;        
    end
    
    methods (Access = public)
        function this = TShowModelsInMatlab(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Models', 'WEMesh List', this)];
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
                    this.Visualiser = UI.ModelViewer;
                    this.Visualiser.SetModels(this.Inputs(this.IN_MODELS).PullData());
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
classdef TMakeROIFrom3DModelsProjection < Core.TProcessor
    properties (Constant = true)
        IN_MODELS = 1;
        IN_STACK3D = 2;
        IN_STACKFUNCTIONAL = 3;
        OUT_ROI = 1;
    end
    
    properties (Access = public)
        Settings;
    end
    
    methods (Access = public)
        function this = TMakeROIFrom3DModelsProjection(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Models', 'WEMesh List', this), ...
                           Core.TInputPoint('Stack 3D', 'Image Stack', this), ...
                           Core.TInputPoint('Stack functional', 'Image Stack', this)];
            this.Outputs = [Core.TOutputPoint('ROI', '2D ROI', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);            
            models = this.Inputs(this.IN_MODELS).PullData();
            stack3D = this.Inputs(this.IN_STACK3D).PullData();
            stackFunctional = this.Inputs(this.IN_STACKFUNCTIONAL).PullData();
            ROI = Segment3D.MakeROIFrom3DModelsProjection(this.Settings, models, stack3D, stackFunctional);
            this.Outputs(this.OUT_ROI).PushData(ROI);
        end
        
    end
end
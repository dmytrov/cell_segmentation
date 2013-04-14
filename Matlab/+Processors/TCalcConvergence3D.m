classdef TCalcConvergence3D < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        OUT_CONVERGENCE = 1;
    end
    
    properties (Access = public)
        Settings;
    end
    
    methods (Access = public)
        function this = TCalcConvergence3D(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
            this.Outputs = [Core.TOutputPoint('Convergence', 'Convergence Stack', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);            
            stack = this.Inputs(this.IN_STACK).PullData();
            convergence = Segment3D.CalcConvergence(this.Settings, stack);
            this.Outputs(this.OUT_CONVERGENCE).PushData(convergence);
        end
        
    end
end
classdef TTIFFReader < Core.TProcessor
    properties (Constant = true)
        OUT_STACK = 1;
    end
    
    properties (Access = public)
        FileName;
    end
    
    methods (Access = public)
        function this = TTIFFReader(name)
            this = this@Core.TProcessor(name);
            this.Inputs = [];
            this.Outputs = [Core.TOutputPoint('Stack', 'Image Stack', this)];
            
        end
    
        function Run(this)
            Run@Core.TProcessor(this);
            
            data = ImageUtils.LoadTIFF(this.FileName);            
            this.Outputs(this.OUT_STACK).PushData(data);
        end
    end    
end
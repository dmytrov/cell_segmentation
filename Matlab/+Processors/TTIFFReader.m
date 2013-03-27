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
        
        function GetParameters(this, params)
            params.fileName = java.lang.String(this.FileName);
        end
        
        function SetParameters(this, params)
            this.FileName = char(params.fileName);
        end
    end    
end
classdef TLoadTIFF < Core.TProcessor
    properties (Constant = true)
        OUT_STACK = 1;
    end
    
    properties (Access = public)
        FileName;
    end
    
    methods (Access = public)
        function this = TLoadTIFF(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [];
            this.Outputs = [Core.TOutputPoint('Stack', 'Image Stack', this)];
            
        end
    
        function Run(this)
            Run@Core.TProcessor(this);
            
            data = ImageUtils.LoadTIFF(this.FileName);            
            data = this.FilterData(data);
            this.Outputs(this.OUT_STACK).PushData(data);
        end
        
        function res = FilterData(this, data)
            res = data;
            % Use just a small part of the data
            %res = res(1:end/2, 1:end/2, 1:end/4);
        end
        
        function GetParameters(this, params)
            params.fileName = java.lang.String(this.FileName);
        end
        
        function SetParameters(this, params)
            this.FileName = char(params.fileName);
        end
    end    
end
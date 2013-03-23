classdef TTIFFReader < Core.TProcessor
    properties (Access = public)
        FileName;
    end
    
    methods (Access = public)
        function this = TTIFFReader(name)
            this = this@Core.TProcessor(name);
            this.Inputs = [];
            this.Outputs = [Core.TOutputPoint('Image', 'Image Stack', this)];
            
        end
    
        function Run(this)
            Run@Core.TProcessor(this);
            
            data = ImageUtils.LoadTIFF(this.FileName);            
            for other = this.OutputByName('Image').Others
                other.Component.Data = data;
            end
        end
    end    
end
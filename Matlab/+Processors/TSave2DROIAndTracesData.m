classdef TSave2DROIAndTracesData < Core.TProcessor
    properties (Constant = true)
        IN_TRACES = 1;
        IN_ROI = 2;
    end
    
    properties (Access = public)
        Settings;
    end
    
    methods (Access = public)        
        function this = TSave2DROIAndTracesData(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Traces', 'Activity traces', this), ...
                           Core.TInputPoint('ROI', '2D ROI', this)];
            this.Outputs = [];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);                        
            traces = this.Inputs(this.IN_TRACES).PullData();
            ROI =  this.Inputs(this.IN_ROI).PullData();
            
            f = fopen('./out/ROI.txt', 'w');
            try
                this.WriteMatrixToFile(f, ROI);
            catch err
                fclose(f);                        
                rethrow(err);
            end
            
            f = fopen('./out/Traces.txt', 'w');
            try
                this.WriteMatrixToFile(f, traces);
            catch err
                fclose(f);                        
                rethrow(err);
            end
            
        end
        
        function WriteMatrixToFile(this, file, data)
            for k1 = 1:size(data, 1)
                for k2 = 1:size(data, 2)
                    fwrite(file, sprintf('%f\t', data(k1, k2)));
                end
                fwrite(file, sprintf('\r\n'));
            end
        end
    end
end
classdef TSave3DModelAndData < Core.TProcessor
    properties (Constant = true)
        IN_MODELS = 1;
    end
    
    properties (Access = public)
        Settings;
    end
    
    methods (Access = public)        
        function this = TSave3DModelAndData(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Models', 'WEMesh List', this)];
            this.Outputs = [];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);                        
            models = this.Inputs(this.IN_MODELS).PullData();
            lCellData = [];
            for model = models
                lCellData = [lCellData, Segment3D.T3DCellData(model)];
            end
            
            f = fopen('./out/cells.txt', 'w');
            k = 1;
            for cellData = lCellData
                fwrite(f, sprintf('%d\t%s\r\n', k, cellData.ToString()));
                sFilename = ['./out/cell', int2str(k), '.stl'];
                MeshUtils.SaveAsBinarySTL(cellData.mModel, sFilename);
                k = k + 1;
            end
            fclose(f);                        
            
        end
    end
end
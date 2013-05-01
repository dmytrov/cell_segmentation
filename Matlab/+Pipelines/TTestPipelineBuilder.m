classdef TTestPipelineBuilder < Core.TPipelineBuilder
    methods (Access = public)
        function this = TTestPipelineBuilder()
            this = this@Core.TPipelineBuilder('TIFF reading test pipeline');
        end

        function res = Build(this)            
            res = Core.TPipeline(this.Name);
            tiffReader = Processors.TLoadTIFF('Functional scan', res);
            tiffReader.FileName = '../Data/Q5 512.tif';
            visualiser = Processors.TShowStackInMatlab('Stack UI in matlab', res);
            res.AddProcessorsChain({tiffReader, visualiser});
        end
    end
end

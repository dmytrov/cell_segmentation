classdef TCreate3DModelsPipelineBuilder < Core.TPipelineBuilder
    methods (Access = public)
        function this = TCreate3DModelsPipelineBuilder()
            this = this@Core.TPipelineBuilder('Create 3D models');
        end

        function res = Build(this)            
            res = Core.TPipeline(this.Name);
            
            loadTIFF = Processors.TLoadTIFF('Load 3D scan');
            loadTIFF.FileName = '../Data/Q5 512.tif';
            alignStack = Processors.TAlignStack('Align stack');
            classifyRegions = Processors.TClassifyRegions('Classify regions');
            estimateModels = Processors.TEstimateModels('Estimate models');
            showModels = Processors.TShowModels('Show models');
            
            res.AddProcessorsChain({loadTIFF, alignStack, classifyRegions});
            res.ConnectPoints(estimateModels.InputByName('Stack'), alignStack.OutputByName('Stack'));
            res.ConnectPoints(estimateModels.InputByName('Regions'), classifyRegions.OutputByName('Regions'));
            res.AddProcessorsChain({estimateModels, showModels});
            
            settings = Segment3D.TSettings();
            classifyRegions.Settings = settings;
            estimateModels.Settings = settings;
        end
    end
end

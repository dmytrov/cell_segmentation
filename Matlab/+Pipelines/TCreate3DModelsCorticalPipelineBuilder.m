classdef TCreate3DModelsCorticalPipelineBuilder < Core.TPipelineBuilder
    methods (Access = public)
        function this = TCreate3DModelsCorticalPipelineBuilder()
            this = this@Core.TPipelineBuilder('Create 3D models (cortical scan)');
        end

        function res = Build(this)            
            res = Core.TPipeline(this.Name);
            
            loadTIFF = Processors.TLoadTIFFHighPass('Load 3D scan, Hi-Pass', res);
            %loadTIFF.FileName = '';
            loadTIFF.FileName = 'D:\EulersLab\Data\Cortical scan\chunk_green.tif';            
            alignStack = Processors.TAlignStack('Align stack', res);
            calcConvergence = Processors.TCalcConvergence3D('Calculate convergence', res);
            classifyRegions = Processors.TClassifyRegions('Classify regions', res);
            estimateModels = Processors.TEstimateModels('Estimate models', res);
            showModelsInMatlab = Processors.TShowModelsInMatlab('Show models in matlab', res);
            showModelsInJava = Processors.TShowModelsInJava('Show models in CellLab', res);
            showStackAndModelsInMatlab = Processors.TShowStackAndModelsSectionsInMatlab('Show models sections', res);
            save3D = Processors.TSave3DModelAndData('Save 3D models', res);
            
            res.AddProcessorsChain({loadTIFF, alignStack, calcConvergence});
            
            res.ConnectPoints(classifyRegions.InputByName('Stack'), alignStack.OutputByName('Stack'));
            res.ConnectPoints(classifyRegions.InputByName('Convergence'), calcConvergence.OutputByName('Convergence'));
            res.AddComponent(classifyRegions);
            
            res.ConnectPoints(estimateModels.InputByName('Stack'), alignStack.OutputByName('Stack'));
            res.ConnectPoints(estimateModels.InputByName('Regions'), classifyRegions.OutputByName('Regions'));
            res.AddProcessorsChain({estimateModels, showModelsInMatlab}); 
            res.AddProcessorsChain({estimateModels, showModelsInJava});             
            
            res.ConnectPoints(showStackAndModelsInMatlab.InputByName('Stack'), alignStack.OutputByName('Stack'));
            res.ConnectPoints(showStackAndModelsInMatlab.InputByName('Models'), estimateModels.OutputByName('Models'));
            res.AddComponent(showStackAndModelsInMatlab);
            
            res.AddProcessorsChain({estimateModels, save3D});            
            
            settings = Segment3D.TSettings();
            settings.InitForCorticalScan();
            calcConvergence.Settings = settings;
            classifyRegions.Settings = settings;
            estimateModels.Settings = settings;
            alignStack.Enabled = settings.EnableMorphologyStackAlignment;
            classifyRegions.ScanType = 'CORTICAL';
            showStackAndModelsInMatlab.Settings = settings;
        end
    end
end
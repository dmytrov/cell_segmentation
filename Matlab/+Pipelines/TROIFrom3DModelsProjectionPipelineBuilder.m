classdef TROIFrom3DModelsProjectionPipelineBuilder < Core.TPipelineBuilder
    methods (Access = public)
        function this = TROIFrom3DModelsProjectionPipelineBuilder()
            this = this@Core.TPipelineBuilder('ROI from 3D models projection');
        end

        function res = Build(this)            
            res = Core.TPipeline(this.Name);
            
            loadTIFF3D = Processors.TLoadTIFF('Load 3D scan', res);
            loadTIFF3D.FileName = '../Data/Q5 512.tif';
            alignStack3D = Processors.TAlignStack('Align 3D stack', res);
            calcConvergence = Processors.TCalcConvergence3D('Calculate convergence', res);
            classifyRegions = Processors.TClassifyRegions('Classify regions', res);
            estimateModels = Processors.TEstimateModels('Estimate models', res);
            showModelsInMatlab = Processors.TShowModelsInMatlab('Show models in matlab', res);
            showModelsInJava = Processors.TShowModelsInJava('Show models in CellLab', res);
            showStackAndModelsInMatlab = Processors.TShowStackAndModelsSectionsInMatlab('Show models sections', res);
            save3D = Processors.TSave3DModelAndData('Save 3D models', res);
            
            res.AddProcessorsChain({loadTIFF3D, alignStack3D, calcConvergence});
            res.ConnectPoints(classifyRegions.InputByName('Stack'), alignStack3D.OutputByName('Stack'));
            res.ConnectPoints(classifyRegions.InputByName('Convergence'), calcConvergence.OutputByName('Convergence'));
            res.AddComponent(classifyRegions);
            
            res.ConnectPoints(estimateModels.InputByName('Stack'), alignStack3D.OutputByName('Stack'));
            res.ConnectPoints(estimateModels.InputByName('Regions'), classifyRegions.OutputByName('Regions'));
            res.AddProcessorsChain({estimateModels, showModelsInMatlab}); 
            res.AddProcessorsChain({estimateModels, showModelsInJava}); 
            res.AddProcessorsChain({estimateModels, save3D});
            
            loadTIFFFunc = Processors.TLoadTIFF('Load functional scan', res);
            loadTIFFFunc.FileName = '../Data/q1_Ch0.tif';
            alignStackFunc = Processors.TAlignStack('Align functional stack', res);
            alignStackFunc.Mode = 'SINGLE_REFERENCE';
            make2DROI = Processors.TMakeROIFrom3DModelsProjection('Make ROI projecting', res);
            edit2DROI = Processors.TEdit2DROI('Edit ROI', res);            
            extractTraces = Processors.TExtractTraces('Extract traces', res);
            saveTraces = Processors.TSave2DROIAndTracesData('Save traces', res);
            
            res.AddProcessorsChain({loadTIFFFunc, alignStackFunc});
            
            res.ConnectPoints(showStackAndModelsInMatlab.InputByName('Stack'), alignStackFunc.OutputByName('Stack'));
            res.ConnectPoints(showStackAndModelsInMatlab.InputByName('Models'), estimateModels.OutputByName('Models'));
            res.AddComponent(showStackAndModelsInMatlab);

            res.ConnectPoints(make2DROI.InputByName('Models'), estimateModels.OutputByName('Models'));
            res.ConnectPoints(make2DROI.InputByName('Stack 3D'), alignStack3D.OutputByName('Stack'));
            res.ConnectPoints(make2DROI.InputByName('Stack functional'), alignStackFunc.OutputByName('Stack'));
            res.AddComponent(make2DROI);
            
            res.ConnectPoints(edit2DROI.InputByName('Stack'), alignStackFunc.OutputByName('Stack'));
            res.ConnectPoints(edit2DROI.InputByName('ROI'), make2DROI.OutputByName('ROI'));
            res.AddComponent(edit2DROI);            
            
            res.ConnectPoints(extractTraces.InputByName('Stack'), alignStackFunc.OutputByName('Stack'));
            res.ConnectPoints(extractTraces.InputByName('ROI'), edit2DROI.OutputByName('ROI'));
            res.AddComponent(extractTraces);
            
            res.ConnectPoints(saveTraces.InputByName('Traces'), extractTraces.OutputByName('Traces'));
            res.ConnectPoints(saveTraces.InputByName('ROI'), make2DROI.OutputByName('ROI'));
            res.AddComponent(saveTraces);
            
            settings = Segment3D.TSettings();
            calcConvergence.Settings = settings;
            classifyRegions.Settings = settings;
            estimateModels.Settings = settings;
            alignStack3D.Enabled = settings.EnableMorphologyStackAlignment;
            alignStackFunc.Enabled = settings.EnableFunctionalStackAlignment;
            make2DROI.Settings = settings;
        end
    end
end

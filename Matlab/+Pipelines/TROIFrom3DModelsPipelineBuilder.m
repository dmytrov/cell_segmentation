classdef TROIFrom3DModelsPipelineBuilder < Core.TPipelineBuilder
    methods (Access = public)
        function this = TROIFrom3DModelsPipelineBuilder()
            this = this@Core.TPipelineBuilder('ROI from 3D models cut');
        end

        function res = Build(this)            
            res = Core.TPipeline(this.Name);
            
            loadTIFF3D = Processors.TLoadTIFF('Load 3D scan', res);
            loadTIFF3D.FileName = '../Data/Q5 512.tif';
            alignStack3D = Processors.TAlignStack('Align 3D stack', res);
            calcConvergence = Processors.TCalcConvergence3D('Calculate convergence', res);
            classifyRegions = Processors.TClassifyRegions('Classify regions', res);
            estimateModels = Processors.TEstimateModels('Estimate models', res);
            showModels = Processors.TShowModels('Show models', res);
            save3D = Processors.TSave3DModelAndData('Save 3D models', res);
            
            res.AddProcessorsChain({loadTIFF3D, alignStack3D, calcConvergence, classifyRegions});
            res.ConnectPoints(estimateModels.InputByName('Stack'), alignStack3D.OutputByName('Stack'));
            res.ConnectPoints(estimateModels.InputByName('Regions'), classifyRegions.OutputByName('Regions'));
            res.AddProcessorsChain({estimateModels, showModels}); 
            res.AddProcessorsChain({estimateModels, save3D});
            
            loadTIFFFunc = Processors.TLoadTIFF('Load functional scan', res);
            loadTIFFFunc.FileName = '../Data/q1_Ch0.tif';
            alignStackFunc = Processors.TAlignStack('Align functional stack', res);
            alignStackFunc.Mode = 'SINGLE_REFERENCE';
            make2DROI = Processors.TMakeROIFrom3DModelsAndFunctionalScan('Make ROI', res);
            extractTraces = Processors.TExtractTraces('Extract traces', res);
            saveTraces = Processors.TSave2DROIAndTracesData('Save traces', res);
            
            res.AddProcessorsChain({loadTIFFFunc, alignStackFunc});
            res.AddComponent(make2DROI);
            res.AddComponent(extractTraces);
            res.AddComponent(saveTraces);
            
            res.ConnectPoints(make2DROI.InputByName('Models'), estimateModels.OutputByName('Models'));
            res.ConnectPoints(make2DROI.InputByName('Stack 3D'), alignStack3D.OutputByName('Stack'));
            res.ConnectPoints(make2DROI.InputByName('Stack functional'), alignStackFunc.OutputByName('Stack'));
            
            res.ConnectPoints(extractTraces.InputByName('Stack'), alignStackFunc.OutputByName('Stack'));
            res.ConnectPoints(extractTraces.InputByName('ROI'), make2DROI.OutputByName('ROI'));
            
            res.ConnectPoints(saveTraces.InputByName('Traces'), extractTraces.OutputByName('Traces'));
            res.ConnectPoints(saveTraces.InputByName('ROI'), make2DROI.OutputByName('ROI'));
            
            settings = Segment3D.TSettings();
            calcConvergence.Settings = settings;
            classifyRegions.Settings = settings;
            estimateModels.Settings = settings;
            make2DROI.Settings = settings;
        end
    end
end

classdef TTracesFromFunctionalScanPipelineBuilder < Core.TPipelineBuilder
    methods (Access = public)
        function this = TTracesFromFunctionalScanPipelineBuilder()
            this = this@Core.TPipelineBuilder('Extract activity traces (watershed based)');
        end

        function res = Build(this)            
            res = Core.TPipeline(this.Name);
            
            loadTIFF = Processors.TLoadTIFF('Load functional scan', res);
            loadTIFF.FileName = '../Data/Q5 FF2.tif';
            alignStack = Processors.TAlignStack('Align stack', res);
            alignStack.Mode = 'SINGLE_REFERENCE';
            make2DROI = Processors.TMake2DROI('Make ROI', res);
            edit2DROI = Processors.TEdit2DROI('Edit ROI', res);
            extractTraces = Processors.TExtractTraces('Extract traces', res);
            saveTraces = Processors.TSave2DROIAndTracesData('Save traces', res);
            
            res.AddProcessorsChain({loadTIFF, alignStack, make2DROI});
            
            res.ConnectPoints(edit2DROI.InputByName('Stack'), alignStack.OutputByName('Stack'));
            res.ConnectPoints(edit2DROI.InputByName('ROI'), make2DROI.OutputByName('ROI'));
            res.AddComponent(edit2DROI);
            
            res.ConnectPoints(extractTraces.InputByName('Stack'), alignStack.OutputByName('Stack'));
            res.ConnectPoints(extractTraces.InputByName('ROI'), edit2DROI.OutputByName('ROI'));
            res.AddComponent(extractTraces);
            
            res.ConnectPoints(saveTraces.InputByName('Traces'), extractTraces.OutputByName('Traces'));
            res.ConnectPoints(saveTraces.InputByName('ROI'), edit2DROI.OutputByName('ROI'));
            res.AddComponent(saveTraces);   
            
            settings = Segment3D.TSettings();
            alignStack.Enabled = settings.EnableFunctionalStackAlignment;
        end
    end
end

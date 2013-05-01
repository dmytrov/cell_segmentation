classdef TMake2DROICorr < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        OUT_ROI = 1;
    end
    
    properties (Access = public)
        Settings;
    end
    
    methods (Access = public)
        function this = TMake2DROICorr(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
            this.Outputs = [Core.TOutputPoint('ROI', '2D ROI', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);            
            stack = this.Inputs(this.IN_STACK).PullData();
            stackFiltered = SignalUtils.FilterStack(this.Settings, stack, 0.01, 'high');
            imStack = ImageUtils.TImageStack(stackFiltered);
            likelihoodFunction = Segment2DCorr.TRegionLikelihood();
            regionsGraph = Segment2DCorr.TRegionsGraph(imStack, likelihoodFunction);

            regionsGraph.DoClustering();

            ROI = regionsGraph.BuildMap();
            minRegionSize = 5;
            ROI = ImageUtils.RemoveRegionsByMinSize(ROI, minRegionSize);
            this.Outputs(this.OUT_ROI).PushData(ROI);
        end
        
    end
end
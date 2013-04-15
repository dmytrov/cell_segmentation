classdef TEdit2DROI < Core.TProcessor
    properties (Constant = true)
        IN_SCAN = 1;
        IN_ROI = 2;
        OUT_ROI = 1;
    end
    
    properties (Access = public)
        Img;
        ROI;
    end
    
    methods (Access = public)        
        function this = TEdit2DROI(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this), ...
                           Core.TInputPoint('ROI', '2D ROI', this)];
            this.Outputs = [Core.TOutputPoint('ROI', '2D ROI', this)];
        end
    
        function GetParameters(this, params)
            if (~isempty(this.Img))
                logImg = log(this.Img);
                maxImg = max(logImg(:));
                params.img = 255 * logImg / maxImg;
            end
            params.map = this.ROI;
        end
        
        function SetParameters(this, params)
            this.ROI = params.map; 
            this.Outputs(this.OUT_ROI).PushData(this.ROI);
        end
        
        function Run(this)
            Run@Core.TProcessor(this);                        
            this.Img = mean(this.Inputs(this.IN_SCAN).PullData(), 3);
            this.ROI = this.Inputs(this.IN_ROI).PullData();
            this.Outputs(this.OUT_ROI).PushData(this.ROI);
        end
        
        function BindJavaUI(this, ui)
            BindJavaUI@Core.TComponent(this, ui);
%             set(this.ExternalUI, 'AutoClassifyCallback', @(h, e)(OnAutoClassify(this, h, e)));
%             set(this.ExternalUI, 'GetRegionByRayCallback', @(h, e)(OnGetRegionByRay(this, h, e)));
%             set(this.ExternalUI, 'MarkRegionCallback', @(h, e)(OnMarkRegion(this, h, e)));            
%             set(this.ExternalUI, 'DeleteRegionCallback', @(h, e)(OnDeleteRegion(this, h, e)));            
%             set(this.ExternalUI, 'CutRegionCallback', @(h, e)(OnCutRegion(this, h, e)));            
%             this.PushRegionsDataToUI();
%             this.ExternalUI.onNewSurfaces();
        end
        
%         function OnAutoClassify(this, sender, event)
%             this.Pipeline.Run(this, true);
%             this.PushRegionsDataToUI();
%             this.ExternalUI.onNewSurfaces();
%             event.onHandled(); % call java code back
%         end
        
        
    end
end
classdef TApplicationBridge < handle
    properties (Access = public)
        Application;
    end
    
    methods (Access = public)
        function this = TApplicationBridge(application, ui)
            this.Application = application;
            this.BindUI(ui);
        end
        
        function BindUI(this, ui)
            set(ui, 'GetPipelineBuildersCallback', @(h, e)(OnGetPipelineBuilders2(this, h, e)));
            set(ui, 'GetPipelineBuildersCallback', @(h, e)(OnGetPipelineBuilders(this, h, e)));
            %set(ui, 'GetSomeValueCallback', @(h, e)(OnGetPipelineBuilders(this, h, e)));
            ui.onBindingFinished();
        end
        
        function OnGetPipelineBuilders(this, sender, event)
            nBuilders = numel(this.Application.PipelineBuilders);
            event.data = javaArray('java.lang.String', nBuilders);
            for k = 1:nBuilders
                name = this.Application.PipelineBuilders{k}.Name;
                event.data(k) = java.lang.String(name);
            end
            event.onHandled(); % call java code back
        end
        
        function OnGetPipelineBuilders2(this, sender, event)
            nBuilders = numel(this.Application.PipelineBuilders);
            event.data = javaArray('java.lang.String', nBuilders);
            for k = 1:nBuilders-1
                name = this.Application.PipelineBuilders{k}.Name;
                event.data(k) = java.lang.String(name);
            end
            event.onHandled(); % call java code back
        end
    end
        
end
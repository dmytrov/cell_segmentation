classdef TJavaConnector < handle
    properties (Access = public)
        Application;
    end
    
    methods (Access = public)
        function this = TJavaConnector(application, javaInterface)
            this.Application = application;
            this.BindJavaInterface(javaInterface);
        end
        
        function BindJavaInterface(this, ji)
            set(ji, 'GetPipelineBuildersCallback', @(h, e)(OnGetPipelineBuilders(this, h, e)));
            %set(ui, 'GetSomeValueCallback', @(h, e)(OnGetPipelineBuilders(this, h, e)));
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
        
    end
        
end
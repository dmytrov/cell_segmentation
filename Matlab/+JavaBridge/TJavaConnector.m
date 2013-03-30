classdef TJavaConnector < handle
    properties (Access = public)
        Application;
        JavaApplication;
    end
    
    methods (Access = public)
        function this = TJavaConnector(application, javaApplication)
            this.Application = application;
            this.JavaApplication = javaApplication;
            this.BindJavaInterface(javaApplication);
        end
        
        function BindJavaInterface(this, javaApplication)
            ji = javaApplication.getMatlabConnector();
            set(ji, 'GetPipelineBuildersCallback', @(h, e)(OnGetPipelineBuilders(this, h, e)));
            set(ji, 'BuildPipelineCallback', @(h, e)(OnBuildPipeline(this, h, e)));
            set(ji, 'GetComponentsCallback', @(h, e)(OnGetComponents(this, h, e)));
            set(ji, 'RunComponentCallback', @(h, e)(OnRunComponent(this, h, e)));
            set(ji, 'RunPipelineCallback', @(h, e)(OnRunPipeline(this, h, e)));
            set(ji, 'GetComponentParametersCallback', @(h, e)(OnGetComponentParameters(this, h, e)));
            set(ji, 'SetComponentParametersCallback', @(h, e)(OnSetComponentParameters(this, h, e)));             
            set(ji, 'ComponentNativeUICallback', @(h, e)(OnComponentNativeUI(this, h, e)));             
        end        
        
        function OnComponentsStateChange(this)
            descs = this.JavaApplication.createGetComponentsEventData();
            this.FillComponentsDescsList(descs);
            this.JavaApplication.onComponentsStateChange(descs);
        end
        
        function FillComponentsDescsList(this, descs)
            for k = this.Application.Pipeline.Components'
                component = k{1};
                desc = descs.createComponentDescription();
                desc.type = java.lang.String(component.GetUIClass());
                desc.name = java.lang.String(component.Name);
                desc.state = component.State;
                descs.add(desc);
            end
        end
        
        function OnGetPipelineBuilders(this, sender, event)
            nBuilders = numel(this.Application.PipelineBuilders);
            event.data.names = javaArray('java.lang.String', nBuilders);
            for k = 1:nBuilders
                name = this.Application.PipelineBuilders{k}.Name;
                event.data.names(k) = java.lang.String(name);
            end
            event.onHandled(); % call java code back
        end
        
        function OnBuildPipeline(this, sender, event)
            this.Application.BuildPipelineByName(event.data.name);
            this.Application.Pipeline.OnComponentsStateChangeCallback = @()(this.OnComponentsStateChange());
            event.onHandled(); % call java code back
        end
        
        function OnGetComponents(this, sender, event)
            this.FillComponentsDescsList(event.data);
            event.onHandled(); % call java code back
        end
        
        function OnRunComponent(this, sender, event)
            component = this.Application.Pipeline.ComponentByName(event.data.name);
            if (~isempty(component))
                this.Application.Pipeline.Run(component, true);
            end
            event.onHandled(); % call java code back
        end
        
        function OnRunPipeline(this, sender, event)
            this.Application.Pipeline.RunAll();
            event.onHandled(); % call java code back
        end
                
        function OnGetComponentParameters(this, sender, event)
            component = this.Application.Pipeline.ComponentByName(event.data.name);
            if (~isempty(component))
                component.GetParameters(event.data.params);
            end
            event.onHandled(); % call java code back
        end
        
        function OnSetComponentParameters(this, sender, event)
            component = this.Application.Pipeline.ComponentByName(event.data.name);
            if (~isempty(component))
                component.SetParameters(event.data.params);
            end
            event.onHandled(); % call java code back
        end
        
        function OnComponentNativeUI(this, sender, event)
            component = this.Application.Pipeline.ComponentByName(event.data.name);
            if (~isempty(component))
                component.SetNativeUIVisible(event.data.visible);
            end
            event.onHandled(); % call java code back
        end
    end
        
end





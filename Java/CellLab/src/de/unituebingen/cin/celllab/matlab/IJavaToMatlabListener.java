package de.unituebingen.cin.celllab.matlab;

import java.awt.Color;

import de.unituebingen.cin.celllab.matlab.EventResultHandler;

// Interface name must end with "Listener" to be visible to matlab code. 
// All methods are visible to matlab as %methodName%Callback
public interface IJavaToMatlabListener extends java.util.EventListener {
	
	//---------------------------------------------------------------------------------------
	public class GetPipelineBuildersEventData {
		public String[] names = new String[0];
	}
	
	public class GetPipelineBuildersResultHandler extends EventResultHandler<GetPipelineBuildersEventData> {		
	}
	
	public class GetPipelineBuildersEvent extends JavaToMatlabEvent<GetPipelineBuildersEventData> {
        private static final long serialVersionUID = 1L;
        
        public GetPipelineBuildersEvent(Object source, GetPipelineBuildersResultHandler erh) {
            super(source, new GetPipelineBuildersEventData(), erh);
        }
    }
	
    void getPipelineBuilders(GetPipelineBuildersEvent event);

    //---------------------------------------------------------------------------------------
    public class BuildPipelineEventData {
    	public String name;
    }
    
    public class BuildPipelineResultHandler extends EventResultHandler<BuildPipelineEventData> {		
	}
	
    public class BuildPipelineEvent extends JavaToMatlabEvent<BuildPipelineEventData> {
        private static final long serialVersionUID = 1L;
        
        public BuildPipelineEvent(Object source, BuildPipelineResultHandler erh) {
            super(source, new BuildPipelineEventData(), erh);
        }
    }
			
    void buildPipeline(BuildPipelineEvent event);
    
    //---------------------------------------------------------------------------------------
    public class RunPipelineEventData {    
    }
    
    public class RunPipelineResultHandler extends EventResultHandler<RunPipelineEventData> {		
	}
	
    public class RunPipelineEvent extends JavaToMatlabEvent<RunPipelineEventData> {
        private static final long serialVersionUID = 1L;
        
        public RunPipelineEvent(Object source, RunPipelineResultHandler erh) {
            super(source, new RunPipelineEventData(), erh);
        }
    }
    
    void runPipeline(RunPipelineEvent event);
    
    //---------------------------------------------------------------------------------------
    public class ComponentState {
    	static final int VALID = 0;
    	static final int INVALID = 1;
    	static final int RUNNING = 2;
    }
    public class ComponentDescription {
    	public String type;
    	public String name;
    	public int state;
    	public Color getColor() {
    		switch (state) {
    			case ComponentState.VALID :
    				return new Color(100, 255, 100);
    			case ComponentState.INVALID :
    				return new Color(255, 100, 100);
    			case ComponentState.RUNNING :
    				return new Color(100, 100, 100);
    			default :
    				// TODO: throw an exception
    				return new Color(0, 0, 0);
    		}
    	}
    }
    
    public class GetComponentsEventData extends java.util.ArrayList<ComponentDescription>{
		private static final long serialVersionUID = 1L;
		public ComponentDescription createComponentDescription() {
			return new ComponentDescription();
		}
    }
    
    public class GetComponentsResultHandler extends EventResultHandler<GetComponentsEventData> {		
	}
    
	public class GetComponentsEvent extends JavaToMatlabEvent<GetComponentsEventData> {
        private static final long serialVersionUID = 1L;
        
        public GetComponentsEvent(Object source, GetComponentsResultHandler erh) {
            super(source, new GetComponentsEventData(), erh);
        }
    }
	
	void getComponents(GetComponentsEvent event);
	
	//---------------------------------------------------------------------------------------
	public class RunComponentEventData {
		public String name;
	}
	
	public class RunComponentResultHandler extends EventResultHandler<RunComponentEventData> {		
	}
	
	public class RunComponentEvent extends JavaToMatlabEvent<RunComponentEventData> {
        private static final long serialVersionUID = 1L;
        
        public RunComponentEvent(Object source, RunComponentResultHandler erh) {
            super(source, new RunComponentEventData(), erh);
        }
    }
	
	void runComponent(RunComponentEvent event);
	
	//---------------------------------------------------------------------------------------
	public class GetComponentParametersEventData {
		public String name;
		public ComponentParameters params;
	}
	
	public class GetComponentParametersResultHandler extends EventResultHandler<GetComponentParametersEventData> {		
	}
	
	public class GetComponentParametersEvent extends JavaToMatlabEvent<GetComponentParametersEventData> {
        private static final long serialVersionUID = 1L;
        
        public GetComponentParametersEvent(Object source, GetComponentParametersResultHandler erh) {
            super(source, new GetComponentParametersEventData(), erh);
        }
    }
	
	void getComponentParameters(GetComponentParametersEvent event);
	
	//---------------------------------------------------------------------------------------
	public class SetComponentParametersEventData {
		public String name;
		public ComponentParameters params;
	}
	
	public class SetComponentParametersResultHandler extends EventResultHandler<SetComponentParametersEventData> {		
	}
	
	public class SetComponentParametersEvent extends JavaToMatlabEvent<SetComponentParametersEventData> {
        private static final long serialVersionUID = 1L;
        
        public SetComponentParametersEvent(Object source, SetComponentParametersResultHandler erh) {
            super(source, new SetComponentParametersEventData(), erh);
        }
    }
	
	void setComponentParameters(SetComponentParametersEvent event);

	// ---------------------------------------------------------------------------------------
	public class ComponentNativeUIEventData {
		public String name;
		public boolean visible;
	}

	public class ComponentNativeUIResultHandler extends
			EventResultHandler<ComponentNativeUIEventData> {
	}

	public class ComponentNativeUIEvent extends
			JavaToMatlabEvent<ComponentNativeUIEventData> {
		private static final long serialVersionUID = 1L;

		public ComponentNativeUIEvent(Object source,
				ComponentNativeUIResultHandler erh) {
			super(source, new ComponentNativeUIEventData(), erh);
		}
	}

	void componentNativeUI(ComponentNativeUIEvent event);
	
	// ---------------------------------------------------------------------------------------
	public class BindComponentListenerEventData {
		public String name;
		public ComponentUI ui;
	}
	
	public class BindComponentListenerResultHandler extends 
			EventResultHandler<BindComponentListenerEventData>{		
	}
	
	public class BindComponentListenerEvent extends JavaToMatlabEvent<BindComponentListenerEventData> {
		private static final long serialVersionUID = 1L;

		public BindComponentListenerEvent(Object source, BindComponentListenerResultHandler erh) {
			super(source, new BindComponentListenerEventData(), erh);
		}
	}
	
	void bindComponentListener(BindComponentListenerEvent event);
}

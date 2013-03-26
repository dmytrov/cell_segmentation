package de.unituebingen.cin.celllab.matlab;

import java.awt.Color;

import de.unituebingen.cin.celllab.matlab.EventResultHandler;

// Interface name must end with "Listener" to be visible to matlab code. 
// All methods are visible to matlab as %methodName%Callback
public interface IJavaToMatlabListener extends java.util.EventListener {
	
	public abstract class JavaToMatlabEvent<T> extends java.util.EventObject {
		private static final long serialVersionUID = 1L;
		public T data;
		public EventResultHandler<T> eventResultHandler;

		public JavaToMatlabEvent(Object source, T intiData, EventResultHandler<T> erh) {
			super(source);
			data = intiData;
			eventResultHandler = erh;
			if (eventResultHandler != null) {
				eventResultHandler.onInit(data);
			}
		}

		public void onHandled() {
			if (eventResultHandler != null) {
				eventResultHandler.onHandled(data);
			}
		}
	}
	
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
	//void getComponentParameters(GetComponentParametersEvent event);
	
	//---------------------------------------------------------------------------------------
	//void setComponentParameters(SetComponentParametersEvent event);
    
}

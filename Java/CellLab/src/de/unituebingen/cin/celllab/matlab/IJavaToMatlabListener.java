package de.unituebingen.cin.celllab.matlab;

import de.unituebingen.cin.celllab.matlab.EventResultHandler;

// Interface name must end with "Listener" to be visible to matlab code. 
// All methods are visible to matlab as %methodName%Callback
public interface IJavaToMatlabListener extends java.util.EventListener {
	
	public abstract class JavaToMatlabEvent<T> extends java.util.EventObject {
		private static final long serialVersionUID = 1L;
		public T data;
		public EventResultHandler<T> eventResultHandler;

		public JavaToMatlabEvent(Object source, T dataInit, EventResultHandler<T> erh) {
			super(source);
			data = dataInit;
			eventResultHandler = erh;
		}

		public void onHandled() {
			if (eventResultHandler != null) {
				eventResultHandler.onHandled(data);
			}
		}
	}
	
	//---------------------------------------------------------------------------------------
	public class GetPipelineBuildersResultHandler extends EventResultHandler<String[]> {		
	}
	
	public class GetPipelineBuildersEvent extends JavaToMatlabEvent<String[]> {
        private static final long serialVersionUID = 1L;
        
        public GetPipelineBuildersEvent(Object source, GetPipelineBuildersResultHandler erh) {
            super(source, new String[0], erh);
        }
    }
	
    void getPipelineBuilders(GetPipelineBuildersEvent event);

    //---------------------------------------------------------------------------------------
    public class BuildPipelineResultHandler extends EventResultHandler<String> {		
	}
	
    public class BuildPipelineEvent extends JavaToMatlabEvent<String> {
        private static final long serialVersionUID = 1L;
        
        public BuildPipelineEvent(Object source, BuildPipelineResultHandler erh) {
            super(source, new String(), erh);
        }
    }
			
    void buildPipeline(BuildPipelineEvent event);
  
    //---------------------------------------------------------------------------------------
    public class ComponentDescription {
    	public String type;
    	public String name;
    	public int state;
    }
    
    public class GetComponentsEventData extends java.util.ArrayList<ComponentDescription>{
		private static final long serialVersionUID = 1L;
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
	public class RunComponentResultHandler extends EventResultHandler<String> {		
	}
	
	public class RunComponentEvent extends JavaToMatlabEvent<String> {
        private static final long serialVersionUID = 1L;
        
        public RunComponentEvent(Object source, RunComponentResultHandler erh) {
            super(source, new String(), erh);
        }
    }
	void runComponent(RunComponentEvent event);
	
	//---------------------------------------------------------------------------------------
	//void getComponentParameters(GetComponentParametersEvent event);
	
	//---------------------------------------------------------------------------------------
	//void setComponentParameters(SetComponentParametersEvent event);
    
}

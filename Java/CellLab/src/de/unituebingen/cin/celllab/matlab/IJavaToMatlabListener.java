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
	
	public class GetPipelineBuildersEvent extends JavaToMatlabEvent<String[]> {
        private static final long serialVersionUID = 1L;
        
        public GetPipelineBuildersEvent(Object source, EventResultHandler<String[]> erh) {
            super(source, new String[0], erh);
        }
    }
			
    void getPipelineBuilders(GetPipelineBuildersEvent event);
    
}

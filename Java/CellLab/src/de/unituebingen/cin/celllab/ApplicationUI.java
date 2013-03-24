package de.unituebingen.cin.celllab;

import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener;
import de.unituebingen.cin.celllab.matlab.EventResultHandler;	

public class ApplicationUI {
	public String[] pipelines;
	
	public ApplicationUI() {	
	}
	
	public void onBindingFinished() {
		System.out.println("Binding finished");		
		System.out.println("Calling getPipelineBuilders");
		getPipelineBuilders(new EventResultHandler<String[]>() {
			@Override
			public void onHandled(String[] data) {
				pipelines = data.clone();
				System.out.println("GetPipelineBuildersEvent is handled. Returned:");
	        	for (String name : data) {
	        		System.out.println("\t" + name);
	        	}
			}
		});		
	}	
	
	protected void getPipelineBuilders(EventResultHandler<String[]> resultHandler) {
		if (!listeners.isEmpty()) {
			listeners.firstElement().getPipelineBuilders(new IJavaToMatlabListener.GetPipelineBuildersEvent(this, resultHandler));
		}
	}

    // Vector of listeners. Matlab dynamically implements the full interface and adds only one proxy listener object
    private java.util.Vector<IJavaToMatlabListener> listeners = new java.util.Vector<IJavaToMatlabListener>();
	
    // Add an event subscription. Used by matlab
    public synchronized void addIJavaToMatlabListener(IJavaToMatlabListener lis) {
        listeners.addElement(lis);
    }
    
    // Remove the event subscription. Used by matlab
    public synchronized void removeIJavaToMatlabListener(IJavaToMatlabListener lis) {
        listeners.removeElement(lis);
    }
}

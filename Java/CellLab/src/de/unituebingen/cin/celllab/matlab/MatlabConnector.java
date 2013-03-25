package de.unituebingen.cin.celllab.matlab;

public class MatlabConnector {
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
    
    //------------------------------------------------------------------------------------------
    public void getPipelineBuilders(IJavaToMatlabListener.GetPipelineBuildersResultHandler resultHandler) {
    	listeners.firstElement().getPipelineBuilders(new IJavaToMatlabListener.GetPipelineBuildersEvent(this, resultHandler));
	}
    
    public void buildPipeline(String name, IJavaToMatlabListener.BuildPipelineResultHandler resultHandler) {
    	IJavaToMatlabListener.BuildPipelineEvent event = new IJavaToMatlabListener.BuildPipelineEvent(this, resultHandler);
    	event.data = name;
    	listeners.firstElement().buildPipeline(event);
	}
    
    public void getComponents(IJavaToMatlabListener.GetComponentsResultHandler resultHandler) {
    	listeners.firstElement().getComponents(new IJavaToMatlabListener.GetComponentsEvent(this, resultHandler));
	}
    
    public void runComponent(IJavaToMatlabListener.RunComponentResultHandler resultHandler) {
    	listeners.firstElement().runComponent(new IJavaToMatlabListener.RunComponentEvent(this, resultHandler));    	
	}
}

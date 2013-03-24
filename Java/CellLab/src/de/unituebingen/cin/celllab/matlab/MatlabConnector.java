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
    public void getPipelineBuilders(EventResultHandler<String[]> resultHandler) {
		if (!listeners.isEmpty()) {
			listeners.firstElement().getPipelineBuilders(new IJavaToMatlabListener.GetPipelineBuildersEvent(this, resultHandler));
		}
	}
}

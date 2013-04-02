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
    
    public void buildPipeline(IJavaToMatlabListener.BuildPipelineResultHandler resultHandler) {
    	listeners.firstElement().buildPipeline(new IJavaToMatlabListener.BuildPipelineEvent(this, resultHandler));
	}
    
    public void getComponents(IJavaToMatlabListener.GetComponentsResultHandler resultHandler) {
    	listeners.firstElement().getComponents(new IJavaToMatlabListener.GetComponentsEvent(this, resultHandler));
	}
    
    public void runComponent(IJavaToMatlabListener.RunComponentResultHandler resultHandler) {
    	listeners.firstElement().runComponent(new IJavaToMatlabListener.RunComponentEvent(this, resultHandler));    	
	}
    
    public void runPipeline(IJavaToMatlabListener.RunPipelineResultHandler resultHandler) {
    	listeners.firstElement().runPipeline(new IJavaToMatlabListener.RunPipelineEvent(this, resultHandler));    	
	}
    
    public void getComponentParameters(IJavaToMatlabListener.GetComponentParametersResultHandler resultHandler) {
    	listeners.firstElement().getComponentParameters(new IJavaToMatlabListener.GetComponentParametersEvent(this, resultHandler));    	
	}
    
    public void setComponentParameters(IJavaToMatlabListener.SetComponentParametersResultHandler resultHandler) {
    	listeners.firstElement().setComponentParameters(new IJavaToMatlabListener.SetComponentParametersEvent(this, resultHandler));    	
	}
    
    public void componentNativeUI(IJavaToMatlabListener.ComponentNativeUIResultHandler resultHandler) {
    	listeners.firstElement().componentNativeUI(new IJavaToMatlabListener.ComponentNativeUIEvent(this, resultHandler));    	
	}
    
    public void bindComponentListener(IJavaToMatlabListener.BindComponentListenerResultHandler resultHandler) {
    	listeners.firstElement().bindComponentListener(new IJavaToMatlabListener.BindComponentListenerEvent(this, resultHandler));    	
	}
}

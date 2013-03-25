package de.unituebingen.cin.celllab;

import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener;
import de.unituebingen.cin.celllab.matlab.MatlabConnector;

public class ApplicationUI {
	protected MatlabConnector matlab = new MatlabConnector();
	public String[] pipelines;
	
	public ApplicationUI() {	
	}
	
	public MatlabConnector getMatlabConnector() {
		return matlab;
	}
	
	public void onBindingFinished() {
		System.out.println("Binding finished");
		getPipelineBuilders();
	}
	
	public void getPipelineBuilders() {
		matlab.getPipelineBuilders(new IJavaToMatlabListener.GetPipelineBuildersResultHandler() {
			@Override
			public void onHandled(String[] data) {
				pipelines = data.clone();
				System.out.println("GetPipelineBuildersEvent is handled. Returned:");
	        	for (String name : data) {
	        		System.out.println("\t" + name);
	        	}
	        	buildPipeline(pipelines[0]);
			}
		});		
	}	
	
	public void buildPipeline(String name) {
		IJavaToMatlabListener.BuildPipelineResultHandler q = new IJavaToMatlabListener.BuildPipelineResultHandler() {
			@Override
			public void onHandled(String data) {
				System.out.println("Pipeline is built");
			}
		};		
		matlab.buildPipeline(name, q);
	}
	
    
}

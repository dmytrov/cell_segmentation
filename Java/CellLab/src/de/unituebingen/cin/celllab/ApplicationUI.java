package de.unituebingen.cin.celllab;

import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.BuildPipelineEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.GetPipelineBuildersEventData;
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
			public void onHandled(GetPipelineBuildersEventData data) {
				pipelines = data.names.clone();
				System.out.println("GetPipelineBuildersEvent is handled. Returned:");
	        	for (String name : pipelines) {
	        		System.out.println("\t" + name);
	        	}
	        	buildPipeline(pipelines[0]);
			}
		});		
	}	
	
	public void buildPipeline(final String name) {
		matlab.buildPipeline(new IJavaToMatlabListener.BuildPipelineResultHandler() {
			@Override
			public void onInit(BuildPipelineEventData data) {
				data.name = name;
			}
			@Override
			public void onHandled(BuildPipelineEventData data) {
				System.out.println("Pipeline is built");
			}
		});		
	}
	
    
}

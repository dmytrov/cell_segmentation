package de.unituebingen.cin.celllab;

import de.unituebingen.cin.celllab.matlab.EventResultHandler;	
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
		System.out.println("Calling getPipelineBuilders");
		matlab.getPipelineBuilders(new EventResultHandler<String[]>() {
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
	
	
    
}

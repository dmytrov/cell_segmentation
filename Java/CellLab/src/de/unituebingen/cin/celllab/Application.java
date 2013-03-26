package de.unituebingen.cin.celllab;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JMenuItem;

import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.BuildPipelineEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.GetComponentsEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.GetPipelineBuildersEventData;
import de.unituebingen.cin.celllab.matlab.MatlabConnector;

public class Application {
	protected MatlabConnector matlab = new MatlabConnector();
	public CellLabUI cellLabUI;
	public String[] pipelines;
	public GetComponentsEventData componentsDesc;
	
	public Application() {	
		cellLabUI = new CellLabUI();
		cellLabUI.setVisible(true);
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
				cellLabUI.mnPipeline.removeAll();
	        	for (String name : pipelines) {
	        		System.out.println("\t" + name);
	        		JMenuItem pipelineMenu = new JMenuItem(name);
	        		pipelineMenu.addActionListener(new ActionListener() {						
						@Override
						public void actionPerformed(ActionEvent e) {
							JMenuItem source = (JMenuItem)e.getSource();
							buildPipeline(source.getText());
						}
					});
	        		cellLabUI.mnPipeline.add(pipelineMenu);
	        	}
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
				createConponentsList();
			}
		});		
	}
	
	public void createConponentsList() {
		matlab.getComponents(new IJavaToMatlabListener.GetComponentsResultHandler() {
			@Override
			public void onHandled(GetComponentsEventData data) {
				componentsDesc = data;
				System.out.println("Components list is received");
				cellLabUI.panelPipeline.removeAll();
				for (IJavaToMatlabListener.ComponentDescription desc : componentsDesc) {
					JButton btn = new JButton(desc.name);
					btn.setBackground(desc.getColor());
					cellLabUI.panelPipeline.add(btn);					
					btn.addActionListener(new ActionListener() {
						@Override
						public void actionPerformed(ActionEvent e) {
							System.out.println("Selected component: " + e.getSource().toString());
						}
						
					});
				}
			}
		});
	}
	
    
}

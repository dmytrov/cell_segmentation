package de.unituebingen.cin.celllab;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JMenuItem;

import de.unituebingen.cin.celllab.matlab.ComponentUI;
import de.unituebingen.cin.celllab.matlab.ComponentsBridge;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.BuildPipelineEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.GetComponentParametersEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.GetComponentParametersResultHandler;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.RunComponentEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.RunComponentResultHandler;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.SetComponentParametersEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.SetComponentParametersResultHandler;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.GetComponentsEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.GetPipelineBuildersEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.RunPipelineEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.ComponentDescription;
import de.unituebingen.cin.celllab.matlab.MatlabConnector;
import de.unituebingen.cin.celllab.matlab.components.TIFFReaderUI;

public class Application {
	protected MatlabConnector matlab = new MatlabConnector();
	public CellLabUI cellLabUI;
	public String[] pipelines;
	public ComponentsBridge componentsBridge;
	public GetComponentsEventData componentsDesc;
	public ComponentDescription currentComponentDesc;
	public ComponentUI currentUI;
	
	
	public Application() {
		// Register UI classes for matlab components
		componentsBridge = new ComponentsBridge();
		componentsBridge.registerComponentUI("Processors.TTIFFReader", TIFFReaderUI.class);
		
		componentsDesc = new GetComponentsEventData();
		cellLabUI = new CellLabUI();
		currentUI = null;
		updatePipelinePanel();
		
		cellLabUI.btnRunCurrent.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setComponentParameters(currentComponentDesc, currentUI);
				runComponent(currentComponentDesc);
			}
		});
		
		cellLabUI.btnRunAll.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setComponentParameters(currentComponentDesc, currentUI);
				matlab.runPipeline(new IJavaToMatlabListener.RunPipelineResultHandler() {
					@Override
					public void onHandled(RunPipelineEventData data) {
						createConponentsList();
					}
				});
			}
		});
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
				openComponentUI(null);
			}
		});		
	}
	
	public void createConponentsList() {
		matlab.getComponents(new IJavaToMatlabListener.GetComponentsResultHandler() {
			@Override
			public void onHandled(GetComponentsEventData data) {
				System.out.println("Components list is received");
				componentsDesc = data;
				updatePipelinePanel();
			}
		});
	}
	
	public void updatePipelinePanel() {
		cellLabUI.panelPipeline.removeAll();
		int k = 0;
		for (ComponentDescription desc : componentsDesc) {
			JButton btn = new JButton(desc.name);
			btn.setBackground(desc.getColor());
			btn.putClientProperty("description", desc);
			cellLabUI.panelPipeline.add(btn, String.format("cell 0 %d,alignx left,aligny top", k));					
			btn.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent e) {
					ComponentDescription compDesc = (ComponentDescription)((JButton)e.getSource()).getClientProperty("description");
					openComponentUI(compDesc);
				}				
			});
			k++;
		}
		cellLabUI.panelPipeline.revalidate();
		cellLabUI.panelPipeline.repaint();
	}

	public void openComponentUI(ComponentDescription desc) {
		currentComponentDesc = desc;
		currentUI = null;
		cellLabUI.panelComponent.removeAll();
		if (desc != null) {
			currentUI = componentsBridge.createUIByMatlabClassName(desc.type);
			if (currentUI != null) {
				cellLabUI.panelComponent.add(currentUI);
				getComponentParameters(currentComponentDesc, currentUI);
			}
		}
		cellLabUI.panelComponent.revalidate();
		cellLabUI.panelComponent.repaint();
	}
	
    public void getComponentParameters(final ComponentDescription desc, final ComponentUI ui) {
    	if ((ui == null) || !(ui instanceof ComponentUI)) {
    		return;
    	}
    	matlab.getComponentParameters(new GetComponentParametersResultHandler() {
    		@Override
			public void onInit(GetComponentParametersEventData data) {
    			data.name = desc.name;
    			data.params = ui.getParameters();
    		}
    		@Override
			public void onHandled(GetComponentParametersEventData data) {
    			ui.setParameters(data.params);
    		}
    	});
    }
    
    public void setComponentParameters(final ComponentDescription desc, final ComponentUI ui) {
    	if ((ui == null) || !(ui instanceof ComponentUI)) {
    		return;
    	}
    	matlab.setComponentParameters(new SetComponentParametersResultHandler() {
    		@Override
			public void onInit(SetComponentParametersEventData data) {
    			data.name = desc.name;
    			data.params = ui.getParameters();
    		}
    	});
    }
    
    public void runComponent(final ComponentDescription desc) {
    	if (desc == null) {
    		return;
    	}
    	matlab.runComponent(new RunComponentResultHandler() {
    		@Override
			public void onInit(RunComponentEventData data) {
    			data.name = desc.name;
    		}
    		@Override
			public void onHandled(RunComponentEventData data) {
				createConponentsList();
			}
    	});
    }
}

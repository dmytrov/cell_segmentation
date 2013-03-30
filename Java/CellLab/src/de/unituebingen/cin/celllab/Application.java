package de.unituebingen.cin.celllab;

import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JMenuItem;
import javax.swing.JToggleButton;

import de.unituebingen.cin.celllab.matlab.ComponentUI;
import de.unituebingen.cin.celllab.matlab.ComponentsBridge;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.BuildPipelineEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.ComponentNativeUIEventData;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.ComponentNativeUIResultHandler;
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
import de.unituebingen.cin.celllab.matlab.components.LoadTIFFUI;

public class Application {
	protected MatlabConnector matlab = new MatlabConnector();
	public CellLabUI cellLabUI;
	public String[] pipelines;
	public ComponentsBridge componentsBridge;
	public GetComponentsEventData componentsDesc;
	public int currentComponent;
	public ComponentUI currentUI;
	
	
	public Application() {
		// Register UI classes for matlab components
		componentsBridge = new ComponentsBridge();
		componentsBridge.registerComponentUI("Processors.TLoadTIFF", LoadTIFFUI.class);
		
		componentsDesc = new GetComponentsEventData();
		cellLabUI = new CellLabUI();
		currentUI = null;
		updatePipelinePanel();
		
		cellLabUI.btnRunCurrent.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setComponentParameters(getCurrentComponentDesc(), currentUI);
				runComponent(getCurrentComponentDesc());
			}
		});
		
		cellLabUI.btnRunAll.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setComponentParameters(getCurrentComponentDesc(), currentUI);
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
	
	public ComponentDescription getCurrentComponentDesc() {
		if ((currentComponent >= 0) && (currentComponent < componentsDesc.size())) {
			return componentsDesc.get(currentComponent);
		} else {
			return null;
		}		
	}
	
	public MatlabConnector getMatlabConnector() {
		return matlab;
	}
	
	public GetComponentsEventData createGetComponentsEventData() {
		return new GetComponentsEventData();
	}
	
	public void onComponentsStateChange(GetComponentsEventData descs) {
		componentsDesc = descs;
		updatePipelinePanel();
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
			JToggleButton btn = new JToggleButton(desc.name);
			btn.setBackground(desc.getColor());
			btn.setSelected(desc == getCurrentComponentDesc());
			btn.putClientProperty("description", desc);
			cellLabUI.panelPipeline.add(btn, String.format("cell 0 %d,alignx left,aligny top", k));					
			btn.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent e) {
					onComponentSelected(e);					
				}				
			});
			k++;
		}
		cellLabUI.panelPipeline.revalidate();
		cellLabUI.panelPipeline.repaint();
	}
	
	public void onComponentSelected(ActionEvent e) {
		JToggleButton selectedButton = (JToggleButton)e.getSource();
		ComponentDescription desc = (ComponentDescription)(selectedButton).getClientProperty("description");
		selectedButton.setSelected(true);
		
		if (getCurrentComponentDesc() != desc) {
			setComponentParameters(getCurrentComponentDesc(), currentUI); // flush current component parameters before reopening new
			openComponentUI(desc);
			updatePipelinePanel();
		}
	}
	
	public void openComponentUI(ComponentDescription desc) {
		nativeComponentUI(getCurrentComponentDesc(), false);
		currentComponent = componentsDesc.indexOf(desc);
		currentUI = null;
		cellLabUI.panelComponent.removeAll();
		if (desc != null) {
			currentUI = componentsBridge.createUIByMatlabClassName(desc.type);
			if (currentUI != null) {
				cellLabUI.panelComponent.add(currentUI);
				getComponentParameters(getCurrentComponentDesc(), currentUI);
			}
		}
		cellLabUI.panelComponent.revalidate();
		cellLabUI.panelComponent.repaint();
		nativeComponentUI(getCurrentComponentDesc(), true);
	}
	
	public void nativeComponentUI(final ComponentDescription desc, final boolean visible) {
		if (desc == null) {
			return;
		}
		matlab.componentNativeUI(new ComponentNativeUIResultHandler() {
			@Override
			public void onInit(ComponentNativeUIEventData data) {
    			data.name = desc.name;
    			data.visible = visible;
    		}
		});
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
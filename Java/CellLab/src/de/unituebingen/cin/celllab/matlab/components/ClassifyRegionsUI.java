package de.unituebingen.cin.celllab.matlab.components;

import de.unituebingen.cin.celllab.math.basic3d.Vector3d;
import de.unituebingen.cin.celllab.matlab.ComponentParameters;
import de.unituebingen.cin.celllab.matlab.ComponentUI;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.GetRegionByRayEvent;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.GetRegionByRayEventData;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.GetRegionByRayResultHandler;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.SynchronousEvent;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.EmptyEvent;

import java.awt.BorderLayout;
import java.util.ArrayList;

import javax.swing.JToolBar;
import javax.swing.JButton;

import de.unituebingen.cin.celllab.opengl.Controller;
import de.unituebingen.cin.celllab.opengl.DoubleBufferGLJPanel;
import de.unituebingen.cin.celllab.opengl.IndexMesh;
import de.unituebingen.cin.celllab.opengl.SceneLayer;
import de.unituebingen.cin.celllab.opengl.SceneLayerBackground;
import de.unituebingen.cin.celllab.opengl.SceneLayerMouseRotationControl;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class ClassifyRegionsUI extends ComponentUI {
	public ArrayList<IndexMesh> surfaces = new ArrayList<IndexMesh>();	
	protected ClassifyRegionsSceneLayer3D scene3D;
	protected SceneLayerMouseRotationControl sceneMouseRot;

	private static final long serialVersionUID = 1L;
	public JToolBar toolBar;
	public JButton btnAuto;
	public DoubleBufferGLJPanel doubleBufferGLJPanel;

	public ClassifyRegionsUI() {
		setLayout(new BorderLayout(0, 0));
		
		toolBar = new JToolBar();
		add(toolBar, BorderLayout.NORTH);
		
		btnAuto = new JButton("Auto");
		btnAuto.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				autoClassify();
			}
		});
		toolBar.add(btnAuto);
		
		doubleBufferGLJPanel = new DoubleBufferGLJPanel();
		add(doubleBufferGLJPanel, BorderLayout.CENTER);
		
		build3DScene();
	}
	
	public void build3DScene() {
		SceneLayer sceneRoot = new SceneLayer("Root", null);
		sceneMouseRot = new SceneLayerMouseRotationControl("Mouse rotation", sceneRoot);
		sceneMouseRot.transform.translation.z = - 150;
		scene3D = new ClassifyRegionsSceneLayer3D("3D", sceneMouseRot, this);
		scene3D.transform.translation.x = - 50; 
		scene3D.transform.translation.y = - 50;
		scene3D.transform.translation.z = - 25;
		@SuppressWarnings("unused")
		SceneLayer sceneBackground = new SceneLayerBackground("Background", sceneRoot);
		Controller controller = new Controller();
		controller.attachScene(sceneRoot);
		controller.attachRenderer(doubleBufferGLJPanel);
		controller.attachUIComponent(doubleBufferGLJPanel);
	}
			
	public class ClassifyRegionsUIParameters extends ComponentParameters {
		//public String fileName; 
	}
	
	@Override
	public ComponentParameters getParameters() {
		ClassifyRegionsUIParameters params = new ClassifyRegionsUIParameters();
		return params;		
	}
	
	@Override
	public void setParameters(ComponentParameters parameters) {
		ClassifyRegionsUIParameters params = (ClassifyRegionsUIParameters)parameters;
	}
	
	//-------------------------------------------------------------------
	private java.util.Vector<IClassifyRegionsUIListener> listeners = new java.util.Vector<IClassifyRegionsUIListener>();
		
	// Add an event subscription. Used by matlab
	public synchronized void addIClassifyRegionsUIListener(IClassifyRegionsUIListener lis) {
		listeners.addElement(lis);
	}
	    
	// Remove the event subscription. Used by matlab
	public synchronized void removeIClassifyRegionsUIListener(IClassifyRegionsUIListener lis) {
		listeners.removeElement(lis);
	}
	
	//-------------------------------------------------------------------
	public void autoClassifySyncCall() {
		if (!listeners.isEmpty()) {
			SynchronousEvent event = new SynchronousEvent(this);
			listeners.firstElement().autoClassify(event);
			event.waitUntilHandled();
		}
	}
	
	public void autoClassify() {
		if (!listeners.isEmpty()) {
			listeners.firstElement().autoClassify(new EmptyEvent(this));
		}
	}
	
	public void onNewSurfaces() {
		// New surfaces data is available now
		for (IndexMesh surface : surfaces) {
			if (surface.tag == 1) {
				surface.color = new float[] {0.8f, 0.2f, 0.2f};
			} else {
				surface.color = new float[] {0.5f, 0.5f, 0.5f};
			}			
		}
		scene3D.renderables.clear();
		scene3D.renderables.addAll(surfaces);
		doubleBufferGLJPanel.repaint();
		System.out.println("New surfaces received");
	}
	
	public void getRegionByRay(final Vector3d ptRay, final Vector3d vRay) {
		if (!listeners.isEmpty()) {
			listeners.firstElement().getRegionByRay(new GetRegionByRayEvent(this, 
					new GetRegionByRayResultHandler(){
				@Override
				public void onInit(GetRegionByRayEventData data) {
					data.ptRay = ptRay.toArray();
					data.vRay = vRay.toArray();
				}
				@Override
				public void onHandled(GetRegionByRayEventData data) {
					for (IndexMesh surface : surfaces) {
						surface.selected = false;
					}
					if (data.kSelected >= 0) {
						surfaces.get(data.kSelected).selected = true;
					}
					doubleBufferGLJPanel.repaint();
				}
			}));
		}
	}
	
	
}

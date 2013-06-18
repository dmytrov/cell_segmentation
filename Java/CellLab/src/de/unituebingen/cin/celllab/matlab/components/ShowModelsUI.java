package de.unituebingen.cin.celllab.matlab.components;


import de.unituebingen.cin.celllab.matlab.ComponentParameters;
import de.unituebingen.cin.celllab.matlab.ComponentUI;

import java.awt.BorderLayout;
import java.util.ArrayList;

import javax.swing.SwingUtilities;

import de.unituebingen.cin.celllab.opengl.Controller;
import de.unituebingen.cin.celllab.opengl.DoubleBufferGLJPanel;
import de.unituebingen.cin.celllab.opengl.IndexMesh;
import de.unituebingen.cin.celllab.opengl.SceneLayer;
import de.unituebingen.cin.celllab.opengl.SceneLayer3D;
import de.unituebingen.cin.celllab.opengl.SceneLayerBackground;
import de.unituebingen.cin.celllab.opengl.SceneLayerLight;
import de.unituebingen.cin.celllab.opengl.SceneLayerMouseRotationControl;

public class ShowModelsUI extends ComponentUI {
	public class RegionType {
		public static final int UNCLASSIFIED    = 0;
		public static final int CELL            = 1;
	}
	public ArrayList<IndexMesh> surfaces = new ArrayList<IndexMesh>();
	protected DoubleBufferGLJPanel doubleBufferGLJPanel;
	protected SceneLayer3D scene3D;
	protected SceneLayerMouseRotationControl sceneMouseRot;

	private static final long serialVersionUID = 1L;

	public ShowModelsUI() {
		setLayout(new BorderLayout(0, 0));
		
		doubleBufferGLJPanel = new DoubleBufferGLJPanel();
		add(doubleBufferGLJPanel, BorderLayout.CENTER);
		
		build3DScene();
	}
	
	public void build3DScene() {
		SceneLayer sceneRoot = new SceneLayer("Root", null);
		SceneLayerLight sceneLight = new SceneLayerLight("Light", sceneRoot);
		sceneLight.lightPos = new float[] {-50, 100, 20, 1};
		sceneMouseRot = new SceneLayerMouseRotationControl("Mouse rotation", sceneLight);
		sceneMouseRot.transform.translation.z = - 160;
		scene3D = new SceneLayer3D("3D", sceneMouseRot);
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
			
	public class ShowModelsUIParameters extends ComponentParameters {
	}
	
	@Override
	public ComponentParameters getParameters() {
		ShowModelsUIParameters params = new ShowModelsUIParameters();
		return params;		
	}
	
	@Override
	public void setParameters(ComponentParameters parameters) {
		@SuppressWarnings("unused")
		ShowModelsUIParameters params = (ShowModelsUIParameters)parameters;
	}
		
	//-------------------------------------------------------------------
	public void onNewSurfaces() {
		SwingUtilities.invokeLater(new Runnable() {
		    public void run() {
		    	onNewSurfacesThreadMethod();		      
		    }
		});
	}
	
	private void onNewSurfacesThreadMethod() {
		pushSurfacesToControls();		
		System.out.println("New surfaces received");
	}
	
	public void pushSurfacesToControls() {
		// New surfaces data is available now
		for (IndexMesh surface : surfaces) {
			surface.colorFactor = new float[] {0.8f, 0.2f, 0.2f, 1.0f};
			surface.visible = true;
		}
		synchronized(scene3D.renderables) {
			scene3D.renderables.clear();
			scene3D.renderables.addAll(surfaces);
		}
		doubleBufferGLJPanel.repaint();		
	}
		
}

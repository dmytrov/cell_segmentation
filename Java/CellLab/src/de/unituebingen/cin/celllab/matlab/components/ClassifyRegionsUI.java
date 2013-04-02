package de.unituebingen.cin.celllab.matlab.components;

import de.unituebingen.cin.celllab.matlab.ComponentParameters;
import de.unituebingen.cin.celllab.matlab.ComponentUI;
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
import de.unituebingen.cin.celllab.opengl.SceneLayer3D;
import de.unituebingen.cin.celllab.opengl.SceneLayerBackground;
import de.unituebingen.cin.celllab.opengl.SceneLayerMouseRotationControl;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class ClassifyRegionsUI extends ComponentUI {
	public ArrayList<IndexMesh> surfaces = new ArrayList<IndexMesh>();
	protected SceneLayer3D scene3D;

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
		SceneLayer sceneMouseRot = new SceneLayerMouseRotationControl("Mouse rotation", sceneRoot);
		scene3D = new SceneLayer3D("3D", sceneMouseRot);
		@SuppressWarnings("unused")
		SceneLayer sceneBackground = new SceneLayerBackground("Background", sceneRoot);
		Controller controller = new Controller();
		controller.attachScene(sceneRoot);
		controller.attachRenderer(doubleBufferGLJPanel);
		controller.attachUIComponent(doubleBufferGLJPanel);
	}
			
	public class ClassifyRegionsUIParameters extends ComponentParameters {
		public String fileName; 
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
		scene3D.renderables.clear();
		scene3D.renderables.addAll(surfaces);
		doubleBufferGLJPanel.repaint();
		System.out.println("New surfaces received");
	}
	
}

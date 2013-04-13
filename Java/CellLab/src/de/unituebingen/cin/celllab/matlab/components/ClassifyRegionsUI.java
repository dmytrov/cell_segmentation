package de.unituebingen.cin.celllab.matlab.components;

import de.unituebingen.cin.celllab.math.basic3d.Vector3d;
import de.unituebingen.cin.celllab.matlab.ComponentParameters;
import de.unituebingen.cin.celllab.matlab.ComponentUI;
import de.unituebingen.cin.celllab.matlab.components.ClassifyRegionsSceneLayer3D.Mode;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.AutoClassifyEvent;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.CutRegionEvent;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.CutRegionEventData;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.CutRegionResultHandler;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.DeleteRegionEvent;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.DeleteRegionEventData;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.DeleteRegionResultHandler;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.GetRegionByRayEvent;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.GetRegionByRayEventData;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.GetRegionByRayResultHandler;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.MarkRegionEvent;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.MarkRegionEventData;
import de.unituebingen.cin.celllab.matlab.components.IClassifyRegionsUIListener.MarkRegionResultHandler;

import java.awt.BorderLayout;
import java.util.ArrayList;

import javax.swing.JToolBar;
import javax.swing.JButton;

import de.unituebingen.cin.celllab.opengl.Controller;
import de.unituebingen.cin.celllab.opengl.DoubleBufferGLJPanel;
import de.unituebingen.cin.celllab.opengl.IndexMesh;
import de.unituebingen.cin.celllab.opengl.SceneLayer;
import de.unituebingen.cin.celllab.opengl.SceneLayerBackground;
import de.unituebingen.cin.celllab.opengl.SceneLayerLight;
import de.unituebingen.cin.celllab.opengl.SceneLayerMouseRotationControl;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class ClassifyRegionsUI extends ComponentUI {
	public class RegionType {
		public static final int UNCLASSIFIED    = 0;
		public static final int CELL            = 1;
	}
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
		
		btnMarkAsCell = new JButton("Mark as cell");
		btnMarkAsCell.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				markCurrentRegion(RegionType.CELL);
			}
		});
		toolBar.add(btnMarkAsCell);
		
		btnMarkAsNoise = new JButton("Mark as noise");
		btnMarkAsNoise.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				markCurrentRegion(RegionType.UNCLASSIFIED);
			}
		});
		toolBar.add(btnMarkAsNoise);
		
		btnCutRegion = new JButton("Cut region");
		btnCutRegion.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				enterCutRegionMode();
			}
		});
		toolBar.add(btnCutRegion);
		
		btnDeleteRegion = new JButton("Delete region");
		btnDeleteRegion.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				deleteCurrentRegion();
			}
		});
		toolBar.add(btnDeleteRegion);
		
		doubleBufferGLJPanel = new DoubleBufferGLJPanel();
		add(doubleBufferGLJPanel, BorderLayout.CENTER);
		
		build3DScene();
	}
	
	public void build3DScene() {
		SceneLayer sceneRoot = new SceneLayer("Root", null);
		SceneLayerLight sceneLight = new SceneLayerLight("Light", sceneRoot);
		sceneLight.lightPos = new float[] {-50, 100, 20, 1};
		sceneMouseRot = new SceneLayerMouseRotationControl("Mouse rotation", sceneLight);
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
	public JButton btnMarkAsCell;
	public JButton btnMarkAsNoise;
	public JButton btnCutRegion;
	public JButton btnDeleteRegion;
		
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
			AutoClassifyEvent event = new AutoClassifyEvent(this);
			listeners.firstElement().autoClassify(event);
			event.waitUntilHandledCatchExceptions();
		}
	}
	
	public void autoClassify() {
		if (!listeners.isEmpty()) {
			AutoClassifyEvent event = new AutoClassifyEvent(this);
			listeners.firstElement().autoClassify(event);
		}
	}

	public void markCurrentRegion(final int marker) {
		if (listeners.isEmpty()) {
			return;
		}
		final int kSelected = getSelectedRegionID();
		if (kSelected >=0) {
			listeners.firstElement().markRegion(new MarkRegionEvent(this, 
					new MarkRegionResultHandler(){
				@Override
				public void onInit(MarkRegionEventData data) {
					data.regionID = kSelected;
					data.newMark = marker;
				}
			}));
		}
	}
	
	public void deleteCurrentRegion() {
		if (listeners.isEmpty()) {
			return;
		}
		final int kSelected = getSelectedRegionID();
		if (kSelected >=0) {
			listeners.firstElement().deleteRegion(new DeleteRegionEvent(this, 
					new DeleteRegionResultHandler(){
				@Override
				public void onInit(DeleteRegionEventData data) {
					data.regionID = kSelected;
				}
			}));
		}	
	}	
	
	public void onNewSurfaces() {
		// New surfaces data is available now
		for (IndexMesh surface : surfaces) {
			if (surface.tag == RegionType.CELL) {
				surface.colorFactor = new float[] {0.8f, 0.2f, 0.2f, 1.0f};
			} else {
				surface.colorFactor = new float[] {0.2f, 0.2f, 0.8f, 1.0f};
			}			
		}
		scene3D.renderables.clear();
		scene3D.renderables.addAll(surfaces);
		doubleBufferGLJPanel.repaint();
		System.out.println("New surfaces received");
	}
	
	public void setSelectedRegionID(int kSelected) {
		for (IndexMesh surface : surfaces) {
			surface.selected = false;
		}
		if ((kSelected >= 0) && (kSelected < surfaces.size())) {
			surfaces.get(kSelected).selected = true;
		}
		
	}
	public int getSelectedRegionID() {
		for (int k = 0; k<surfaces.size(); k++) {
			if (surfaces.get(k).selected) {
				return k;
			}
		}
		return -1;
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
					setSelectedRegionID(data.kSelected);					
					doubleBufferGLJPanel.repaint();
				}
			}));
		}
	}
	
	public void enterCutRegionMode() {
		scene3D.mode = Mode.Cut;
	}
	
	public void cutSelectedRegion(final Vector3d pt, final Vector3d vn) {
		if (listeners.isEmpty()) {
			return;
		}
		final int kSelected = getSelectedRegionID();
		if (kSelected >=0) {
			listeners.firstElement().cutRegion(new CutRegionEvent(this, 
					new CutRegionResultHandler(){
				@Override
				public void onInit(CutRegionEventData data) {
					data.regionID = kSelected;
					data.ptPlane = pt.toArray();
					data.vnPlane = vn.toArray();
				}				
			}));
		}
	}
	
}

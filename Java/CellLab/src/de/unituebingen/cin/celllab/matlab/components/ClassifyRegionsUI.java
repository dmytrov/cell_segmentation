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
import javax.swing.JSplitPane;
import javax.swing.JPanel;
import net.miginfocom.swing.MigLayout;
import javax.swing.JSlider;
import javax.swing.JLabel;
import javax.swing.JCheckBox;
import javax.swing.SwingUtilities;

public class ClassifyRegionsUI extends ComponentUI {
	public class RegionType {
		public static final int UNCLASSIFIED    = 0;
		public static final int CELL            = 1;
	}
	public ArrayList<IndexMesh> surfaces = new ArrayList<IndexMesh>();	
	public int[][][] stack = new int[1][1][1];
	public int[][][] overlay = new int[1][1][1];
	protected ClassifyRegionsSceneLayer3D scene3D;
	protected SceneLayerMouseRotationControl sceneMouseRot;

	private static final long serialVersionUID = 1L;
	public JButton btnAuto;
	public DoubleBufferGLJPanel doubleBufferGLJPanel;

	public ClassifyRegionsUI() {
		setLayout(new BorderLayout(0, 0));
		
		splitPane = new JSplitPane();
		add(splitPane, BorderLayout.CENTER);
		
		panel = new JPanel();
		splitPane.setLeftComponent(panel);
		panel.setLayout(new MigLayout("", "[grow]", "[][][][][][][][][][][][][]"));
		
		lblConvergenceThreshold = new JLabel("Convergence threshold, % max:");
		panel.add(lblConvergenceThreshold, "cell 0 0");
		
		panel_1 = new JPanel();
		panel.add(panel_1, "cell 0 1,grow");
		panel_1.setLayout(new BorderLayout(0, 0));
		
		sliderConvergenceThreshold = new JSlider();
		sliderConvergenceThreshold.setMaximum(60);
		sliderConvergenceThreshold.setMinimum(40);
		sliderConvergenceThreshold.setPaintTicks(true);
		sliderConvergenceThreshold.setPaintLabels(true);
		sliderConvergenceThreshold.setMinorTickSpacing(1);
		sliderConvergenceThreshold.setMajorTickSpacing(5);
		panel_1.add(sliderConvergenceThreshold);
		
		lblMinVolume = new JLabel("Min cell volume, micron^3:");
		panel.add(lblMinVolume, "cell 0 2");
		
		panel_2 = new JPanel();
		panel.add(panel_2, "cell 0 3,grow");
		panel_2.setLayout(new BorderLayout(0, 0));
		
		sliderMinCellVolume = new JSlider();
		sliderMinCellVolume.setMaximum(500);
		sliderMinCellVolume.setPaintTicks(true);
		sliderMinCellVolume.setPaintLabels(true);
		sliderMinCellVolume.setMinorTickSpacing(100);
		sliderMinCellVolume.setMajorTickSpacing(100);
		panel_2.add(sliderMinCellVolume, BorderLayout.CENTER);
		
		btnAuto = new JButton("Automatic");
		panel.add(btnAuto, "cell 0 4,growx");
		btnAuto.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				autoClassify();
			}
		});
		
		lblManualEditing = new JLabel("Manual editing:");
		panel.add(lblManualEditing, "cell 0 5");
		
		btnMarkAsCell = new JButton("Mark as cell");
		panel.add(btnMarkAsCell, "cell 0 6,growx");
		btnMarkAsCell.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				markCurrentRegion(RegionType.CELL);
			}
		});
		
		btnMarkAsNoise = new JButton("Mark as noise");
		panel.add(btnMarkAsNoise, "cell 0 7,growx");
		btnMarkAsNoise.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				markCurrentRegion(RegionType.UNCLASSIFIED);
			}
		});
		
		btnCutRegion = new JButton("Cut region");
		panel.add(btnCutRegion, "cell 0 8,growx");
		btnCutRegion.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				enterCutRegionMode();
			}
		});
		
		btnDeleteRegion = new JButton("Delete region");
		panel.add(btnDeleteRegion, "cell 0 9,growx");
		
		lblVisibilityOptions = new JLabel("Visibility options:");
		panel.add(lblVisibilityOptions, "cell 0 10");
		
		chckbxShowCells = new JCheckBox("Show cells regions");
		chckbxShowCells.setSelected(true);
		chckbxShowCells.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				applyVisibilityOptions();
			}
		});
		panel.add(chckbxShowCells, "cell 0 11");
		
		chckbxShowNoise = new JCheckBox("Show noise regions");
		chckbxShowNoise.setSelected(true);
		chckbxShowNoise.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				applyVisibilityOptions();
			}
		});
		panel.add(chckbxShowNoise, "cell 0 12");
		
		splitPane_1 = new JSplitPane();
		splitPane_1.setResizeWeight(1.0);
		splitPane.setRightComponent(splitPane_1);
		
		doubleBufferGLJPanel = new DoubleBufferGLJPanel();
		splitPane_1.setLeftComponent(doubleBufferGLJPanel);
		
		stackViewerPanel = new JStackViewerPanel();
		splitPane_1.setRightComponent(stackViewerPanel);
		btnDeleteRegion.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				deleteCurrentRegion();
			}
		});
		splitPane.setDividerLocation(170);
		
		build3DScene();
	}
	
	public void build3DScene() {
		SceneLayer sceneRoot = new SceneLayer("Root", null);
		SceneLayerLight sceneLight = new SceneLayerLight("Light", sceneRoot);
		sceneLight.lightPos = new float[] {-50, 100, 20, 1};
		sceneMouseRot = new SceneLayerMouseRotationControl("Mouse rotation", sceneLight);
		sceneMouseRot.transform.translation.z = - 160;
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
		public double convergenceThreshold;
		public double minCellVolume;
	}
	
	@Override
	public ComponentParameters getParameters() {
		ClassifyRegionsUIParameters params = new ClassifyRegionsUIParameters();
		params.convergenceThreshold = (double)sliderConvergenceThreshold.getValue() / 100;
		params.minCellVolume = (double)sliderMinCellVolume.getValue();
		return params;		
	}
	
	@Override
	public void setParameters(ComponentParameters parameters) {
		ClassifyRegionsUIParameters params = (ClassifyRegionsUIParameters)parameters;
		sliderConvergenceThreshold.setValue((int)(params.convergenceThreshold * 100));
		sliderMinCellVolume.setValue((int)params.minCellVolume);
	}
	
	//-------------------------------------------------------------------
	private java.util.Vector<IClassifyRegionsUIListener> listeners = new java.util.Vector<IClassifyRegionsUIListener>();
	public JButton btnMarkAsCell;
	public JButton btnMarkAsNoise;
	public JButton btnCutRegion;
	public JButton btnDeleteRegion;
	public JSplitPane splitPane;
	public JPanel panel;
	public JLabel lblMinVolume;
	public JLabel lblConvergenceThreshold;
	public JPanel panel_1;
	public JSlider sliderConvergenceThreshold;
	public JPanel panel_2;
	public JSlider sliderMinCellVolume;
	public JLabel lblManualEditing;
	public JSplitPane splitPane_1;
	public JStackViewerPanel stackViewerPanel;
	public JLabel lblVisibilityOptions;
	public JCheckBox chckbxShowCells;
	public JCheckBox chckbxShowNoise;
		
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
			this.application.setComponentParameters(this.desc, this);
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
		pushSurfacesToControls();		
		System.out.println("New surfaces received");
	}
	
	public void pushSurfacesToControls() {
		// New surfaces data is available now
		float[][] overlayColorFactor = new float[surfaces.size()+1][4];

		int k = 1;
		for (IndexMesh surface : surfaces) {
			if (surface.tag == RegionType.CELL) {
				surface.colorFactor = new float[] {0.8f, 0.2f, 0.2f, 1.0f};
				surface.visible = getCellsVisible();
			} else {
				surface.colorFactor = new float[] {0.2f, 0.2f, 0.8f, 1.0f};
				surface.visible = getNoiseVisible();
			}
			if (surface.visible) {
				overlayColorFactor[k] = surface.colorFactor;
			} else {
				overlayColorFactor[k] = new float[] {1.0f, 1.0f, 1.0f, 1.0f};
			}
			k++;
		}
		synchronized(scene3D.renderables) {
			scene3D.renderables.clear();
			scene3D.renderables.addAll(surfaces);
		}
		repaintOpenGLControl();
		
		stackViewerPanel.setStack(stack);
		stackViewerPanel.setOverlay(overlay);
		
		stackViewerPanel.setOverlayColorFactor(overlayColorFactor);
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
					data.selectCells = getCellsVisible();
					data.selectNoise = getNoiseVisible();
				}
				@Override
				public void onHandled(GetRegionByRayEventData data) {
					setSelectedRegionID(data.kSelected);					
					repaintOpenGLControl();
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
	
	public void applyVisibilityOptions() {
		pushSurfacesToControls();
	}
		
	protected boolean getCellsVisible() {
		return chckbxShowCells.isSelected(); 
	}
	
	protected boolean getNoiseVisible() {
		return chckbxShowNoise.isSelected(); 
	}
	
	protected void repaintOpenGLControl() {
		SwingUtilities.invokeLater(new Runnable() {
		    public void run() {
		    	doubleBufferGLJPanel.repaint();		      
		    }
		});
	}
}

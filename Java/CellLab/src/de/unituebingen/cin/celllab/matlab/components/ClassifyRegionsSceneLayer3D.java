package de.unituebingen.cin.celllab.matlab.components;

import java.awt.event.MouseEvent;

import de.unituebingen.cin.celllab.math.basic3d.Vector3d;
import de.unituebingen.cin.celllab.opengl.SceneLayer;
import de.unituebingen.cin.celllab.opengl.SceneLayer3D;

public class ClassifyRegionsSceneLayer3D extends SceneLayer3D{
	public ClassifyRegionsUI ui;
	
	public ClassifyRegionsSceneLayer3D(String name, SceneLayer parentLayer, ClassifyRegionsUI ui) {
		super(name, parentLayer);
		this.ui = ui;
	}

	protected boolean handleMousePressedBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		ui.getRegionByRay(ptViewLocal, vViewLocal);
		return true;
	}
	
	protected boolean handleMouseMoveBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {		
		return false;
	}

	protected boolean handleMouseReleasedBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		return false;
	}
}

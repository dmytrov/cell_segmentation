//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import java.awt.event.MouseWheelEvent;

import de.unituebingen.cin.celllab.math.basic3d.*;

public class SceneLayerMouseZoomControl extends SceneLayer {
	protected static final double ZOOM_FACTOR = 3;
	
	public SceneLayerMouseZoomControl(String name, SceneLayer parentLayer) {
		super(name, parentLayer);
	}

	@Override
	protected boolean handleMouseWheelMovedBeforeChildren(MouseWheelEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		// int notches = event.getWheelRotation();
		int scrollUnits = event.getUnitsToScroll();
		Vector3d vShift = new Vector3d(0, 0, ZOOM_FACTOR * scrollUnits); 
		transform.translation.add(vShift);
		event.getComponent().repaint();
		return true;		
	}
			
}

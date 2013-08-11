//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import java.awt.event.KeyEvent;
import java.awt.event.MouseWheelEvent;

import de.unituebingen.cin.celllab.math.basic3d.*;

public class SceneLayerMouseZoomControl extends SceneLayer {
	protected static final double ZOOM_FACTOR = 3;
	
	public SceneLayerMouseZoomControl(String name, SceneLayer parentLayer) {
		super(name, parentLayer);
	}

	@Override
	protected boolean handleMouseWheelMovedBeforeChildren(MouseWheelEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		stepZoom(-ZOOM_FACTOR * event.getUnitsToScroll());
		event.getComponent().repaint();
		return true;		
	}
	
	protected boolean handleKeyPressedBeforeChildren(KeyEvent event) {
		int keyCode = event.getKeyCode();
	    switch( keyCode ) { 
	        case KeyEvent.VK_UP:
	        	stepZoom(ZOOM_FACTOR);
	        	event.getComponent().repaint();
	        	return true;
	        case KeyEvent.VK_DOWN:
	        	stepZoom(-ZOOM_FACTOR);
	        	event.getComponent().repaint();
	        	return true;
	     }
		return false;
	}
	
	protected void stepZoom(double size) {
		Vector3d vShift = new Vector3d(0, 0, size); 
		transform.translation.add(vShift);
	}
	
			
}

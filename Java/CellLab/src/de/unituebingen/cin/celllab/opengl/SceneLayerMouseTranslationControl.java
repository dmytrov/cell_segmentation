//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import java.awt.event.MouseEvent;
//import java.awt.geom.AffineTransform;

import javax.swing.SwingUtilities;
import de.unituebingen.cin.celllab.math.basic3d.*;

public class SceneLayerMouseTranslationControl extends SceneLayer {

	protected static final double MOTION_FACTOR = 3;
	protected boolean moving;
	protected Vector3d ptMotionStart;
	
	public SceneLayerMouseTranslationControl(String name, SceneLayer parentLayer) {
		super(name, parentLayer);
		moving = false;
		ptMotionStart = new Vector3d();
	}
	
	protected Vector3d getPointOnTranslationPlane(Vector3d ptView, Vector3d vView) {
		Vector3d ptPlane = new Vector3d(0, 0, 0);
		Vector3d vnPlane = this.getFullInvertTransform().transformVector(new Vector3d(0, 0, 1));
		return Collision.VectorPlaneIntersect(getPtViewLocal(vView), getVViewLocal(vView), ptPlane, vnPlane);
	}

	@Override
	protected boolean handleMousePressedBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		// Intercept middle mouse click
		if (SwingUtilities.isMiddleMouseButton(event)) {
			//Vector3d ptPlane = new Vector3d(0, 0, 0);
			//Vector3d vnPlane = this.getFullInvertTransform().transformVector(new Vector3d(0, 0, 1));
			//ptMotionStart = Collision.VectorPlaneIntersect(getPtViewLocal(vView), getVViewLocal(vView), ptPlane, vnPlane);
			ptMotionStart = getPointOnTranslationPlane(ptView, vView);
			return true;
		}
		return false;
	}
	
	@Override
	protected boolean handleMouseMoveBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		if (SwingUtilities.isMiddleMouseButton(event)) {
			//Vector3d ptPlane = new Vector3d(0, 0, 0);
			//Vector3d vnPlane = this.getFullInvertTransform().transformVector(new Vector3d(0, 0, 1));
			Vector3d ptMotionEnd = getPointOnTranslationPlane(ptView, vView);
			if (!moving) {
				moving = true;
			}
			else { // already moving
				Vector3d vShift = ptMotionEnd.minus(ptMotionStart); 				
				transform.translation.add(vShift);
				event.getComponent().repaint();
			}
			//vnPlane = this.getFullInvertTransform().transformVector(new Vector3d(0, 0, 1));
			ptMotionStart = getPointOnTranslationPlane(ptView, vView);
			return true;
		}			
		return false;
	}

	@Override
	protected boolean handleMouseReleasedBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		if (moving) {
			moving = false;
			return true;
		}
		return false;
	}

}

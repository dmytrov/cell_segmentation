//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import java.awt.event.MouseEvent;
import javax.swing.SwingUtilities;
import de.unituebingen.cin.celllab.math.basic3d.*;

public class SceneLayerMouseRotationControl extends SceneLayer {

	protected static final double ROTATION_FACTOR = 3;
	protected boolean rotating;
	protected Vector3d vRotationStart;
	
	public SceneLayerMouseRotationControl(String name, SceneLayer parentLayer) {
		super(name, parentLayer);
		rotating = false;
		vRotationStart = new Vector3d();
	}

	@Override
	protected boolean handleMousePressedBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		// Intercept right mouse click
		if (SwingUtilities.isRightMouseButton(event)) {
			return true;
		}
		return false;
	}	
	
	@Override
	protected boolean handleMouseMoveBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		if (SwingUtilities.isRightMouseButton(event)) {
			if (!rotating) {
				rotating = true;
			}
			else { // already rotating
				Vector3d axis = new Vector3d();
				vViewLocal = getParentVViewLocal(vView);
				axis.cross(vRotationStart, vViewLocal);
				AxisAngle4d axisAngle = new AxisAngle4d(axis.x, axis.y, axis.z, -ROTATION_FACTOR * vRotationStart.angle(vViewLocal));
				Quat4d qRot = new Quat4d();
				qRot.set(axisAngle);
				Matrix3d mRot = new Matrix3d();
				mRot.set(qRot);
				transform.rotation.mul(mRot, transform.rotation);
				event.getComponent().repaint();
			}
			vRotationStart.set(getParentVViewLocal(vView));
			return true;
		}			
		return false;
	}

	@Override
	protected boolean handleMouseReleasedBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		if (rotating) {
			rotating = false;
			return true;
		}
		return false;
	}

}

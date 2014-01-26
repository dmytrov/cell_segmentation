package de.unituebingen.cin.celllab.matlab.components;

import java.awt.event.InputEvent;
import java.awt.event.MouseEvent;

import javax.media.opengl.GL;
import javax.media.opengl.GL2;
import javax.media.opengl.GLAutoDrawable;
import javax.vecmath.Vector2d;

import de.unituebingen.cin.celllab.math.basic3d.AffineTransform3d;
import de.unituebingen.cin.celllab.math.basic3d.Vector3d;
import de.unituebingen.cin.celllab.opengl.Camera;
import de.unituebingen.cin.celllab.opengl.SceneLayer;
import de.unituebingen.cin.celllab.opengl.SceneLayer3D;

public class ClassifyRegionsSceneLayer3D extends SceneLayer3D{
	public enum Mode {
		Select,
		Cut
	}
	
	public enum SelectState {
		WaitingStart,
		WaitingEnd
	}
	
	public ClassifyRegionsUI ui;
	public Mode mode = Mode.Select;
	public SelectState selectState = SelectState.WaitingStart;
	private Vector2d ptCutStart = new Vector2d();
	private Vector2d ptCutEnd = new Vector2d();
	private Vector3d vCutStart = new Vector3d();
	private Vector3d vCutEnd = new Vector3d();
	
	public ClassifyRegionsSceneLayer3D(String name, SceneLayer parentLayer, ClassifyRegionsUI ui) {
		super(name, parentLayer);
		this.ui = ui;
	}

	protected boolean handleMousePressedBeforeChildren(MouseEvent event,
			Vector3d ptView, Vector3d vView, Vector3d ptViewLocal,
			Vector3d vViewLocal) {
		switch (mode) {
		case Select:
			break;
		case Cut:
			vCutStart.set(vView);
			ptCutStart.set(event.getX(), event.getComponent().getHeight() - event.getY());
			selectState = SelectState.WaitingEnd;
			break;
		}
		return true;
	}

	protected boolean handleMouseMoveBeforeChildren(MouseEvent event,
			Vector3d ptView, Vector3d vView, Vector3d ptViewLocal,
			Vector3d vViewLocal) {
		switch (mode) {
		case Cut:
			vCutEnd.set(vViewLocal);
			ptCutEnd.set(event.getX(), event.getComponent().getHeight() - event.getY());
			event.getComponent().repaint();
			return true;
		default:		
		}
		return false;
	}

	protected boolean handleMouseReleasedBeforeChildren(MouseEvent event,
			Vector3d ptView, Vector3d vView, Vector3d ptViewLocal,
			Vector3d vViewLocal) {
		switch (mode) {
		case Select:
			if (ui != null) {
				boolean bAddRegion = (event.getModifiers() & InputEvent.CTRL_MASK) == InputEvent.CTRL_MASK;
				ui.getRegionByRay(ptViewLocal, vViewLocal, bAddRegion);
			}
			break;
		case Cut:
			AffineTransform3d transformInv = getFullInvertTransform();
			vCutStart = transformInv.transformVector(vCutStart);
			vCutEnd.set(vViewLocal);
			Vector3d vn = new Vector3d();
			vn.cross(vCutStart, vCutEnd);
			
			selectState = SelectState.WaitingStart;
			mode = Mode.Select;
			
			if (ui != null) {
				ui.cutSelectedRegion(ptViewLocal, vn);
			}
			event.getComponent().repaint();
			break;
		}
		return true;
	}
	
	@Override
	public void renderAfterChildren(GLAutoDrawable drawable) {
		super.renderAfterChildren(drawable);
		
		GL2 gl = drawable.getGL().getGL2();
		switch (mode) {
		case Select:
			break;
		case Cut:
			if (selectState == SelectState.WaitingEnd) {
				Camera.pushProjection(gl);
				Camera.setOrthogonalProjection(drawable);

				gl.glMatrixMode(GL2.GL_MODELVIEW);
				gl.glPushMatrix();
				gl.glLoadIdentity();

				// gl.glDisable(GL.GL_DEPTH_TEST);
				gl.glDisable(GL2.GL_LIGHTING);
				gl.glLineWidth(1f);
				gl.glBegin(GL.GL_LINES);
				gl.glColor3f(1.0f, 0.0f, 0.0f);
				gl.glVertex2d(ptCutStart.x, ptCutStart.y);
				gl.glVertex2d(ptCutEnd.x, ptCutEnd.y);
				gl.glEnd();

				gl.glMatrixMode(GL2.GL_MODELVIEW);
				gl.glPopMatrix();

				Camera.popProjection(gl);
			}
			break;
		}
	}
}

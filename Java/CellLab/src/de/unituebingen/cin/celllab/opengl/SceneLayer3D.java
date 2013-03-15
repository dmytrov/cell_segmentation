//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import java.awt.event.MouseEvent;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;

import de.unituebingen.cin.celllab.math.basic3d.Vector3d;

public class SceneLayer3D extends SceneLayer {

	public SceneLayer3D(String name, SceneLayer parentLayer) {
		super(name, parentLayer);		
	}

	@Override
	public void renderAfterChildren(GLAutoDrawable drawable) {
		//System.out.printf("Rotation matrix: %s", getFullTransform().rotation);
		GL gl = drawable.getGL();
		gl.glBegin(GL.GL_TRIANGLES);
        gl.glColor3f(1.0f, 0.0f, 0.0f); gl.glVertex3f(-1.0f, 0.0f, -10.0f);
        gl.glColor3f(0.0f, 1.0f, 0.0f); gl.glVertex3f( 0.0f, 1.0f, -10.0f);
        gl.glColor3f(0.0f, 0.0f, 1.0f); gl.glVertex3f( 1.0f, 0.0f, -10.0f);
        gl.glEnd();               
	}
	
	@Override
	protected boolean handleMousePressedBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		//System.out.printf("ptView: (%f, %f, %f)\n", ptViewLocal.x, ptViewLocal.y, ptViewLocal.z);
		//System.out.printf("vView: (%f, %f, %f)\n", vViewLocal.x, vViewLocal.y, vViewLocal.z);
		return false;
	}
}

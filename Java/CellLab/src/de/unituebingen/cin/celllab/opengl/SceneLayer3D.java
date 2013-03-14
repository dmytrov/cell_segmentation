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
		GL gl = drawable.getGL();
		gl.glBegin(GL.GL_TRIANGLES);
        gl.glColor3f(1.0f, 0.0f, 0.0f); gl.glVertex3f(-1.0f, 0.0f, -10.0f);
        gl.glColor3f(0.0f, 1.0f, 0.0f); gl.glVertex3f( 0.0f, 1.0f, -10.0f);
        gl.glColor3f(0.0f, 0.0f, 1.0f); gl.glVertex3f( 1.0f, 0.0f, -10.0f);
        gl.glEnd();
                
	}
	
	@Override
	public boolean handleMousePressed(MouseEvent event, Vector3d ptView, Vector3d vView) {
		System.out.printf("ptView: (%f, %f, %f)\n", ptView.x, ptView.y, ptView.z);
		System.out.printf("vView: (%f, %f, %f)\n", vView.x, vView.y, vView.z);
		return super.handleMousePressed(event, ptView, vView);
	}
}

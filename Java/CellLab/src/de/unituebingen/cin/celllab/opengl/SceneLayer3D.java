//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import java.awt.event.MouseEvent;
import java.util.ArrayList;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;

import de.unituebingen.cin.celllab.math.basic3d.Vector3d;

public class SceneLayer3D extends SceneLayer {

	public ArrayList<IRenderable> renderables;
	
	public SceneLayer3D(String name, SceneLayer parentLayer) {
		super(name, parentLayer);
		renderables = new ArrayList<IRenderable>(); 
	}
	
	public void setupLight(GL gl)
	{
        // Enable lighting in GL.
        gl.glEnable(GL.GL_LIGHTING);
        gl.glEnable(GL.GL_LIGHT1);

        // Prepare light parameters.
        float SHINE_ALL_DIRECTIONS = 1;
        float[] lightPos = {-30, 0, 0, SHINE_ALL_DIRECTIONS};
        float[] lightColorAmbient = {0.2f, 0.2f, 0.2f, 1f};
        float[] lightColorSpecular = {0.8f, 0.8f, 0.8f, 1f};

        // Set light parameters.
        gl.glLightfv(GL.GL_LIGHT1, GL.GL_POSITION, lightPos, 0);
        gl.glLightfv(GL.GL_LIGHT1, GL.GL_AMBIENT, lightColorAmbient, 0);
        gl.glLightfv(GL.GL_LIGHT1, GL.GL_SPECULAR, lightColorSpecular, 0);

        // Set material properties.
        float[] rgba = {0.3f, 0.5f, 1f};
        gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT, rgba, 0);
        gl.glMaterialfv(GL.GL_FRONT, GL.GL_SPECULAR, rgba, 0);
        gl.glMaterialf(GL.GL_FRONT, GL.GL_SHININESS, 0.5f);

	}

	@Override
	public void renderAfterChildren(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		setupLight(gl);
		//System.out.printf("Rotation matrix: %s", getFullTransform().rotation);
		for (IRenderable renderable : renderables ) {
			renderable.render(drawable);
		}			
		gl.glBegin(GL.GL_TRIANGLES);
        gl.glColor3f(1.0f, 0.0f, 0.0f); gl.glVertex3f(-1.0f, 0.0f, 1.0f);
        gl.glColor3f(0.0f, 1.0f, 0.0f); gl.glVertex3f( 0.0f, 1.0f, 1.0f);
        gl.glColor3f(0.0f, 0.0f, 1.0f); gl.glVertex3f( 1.0f, 0.0f, 1.0f);
        gl.glEnd();               
	}
	
	@Override
	protected boolean handleMousePressedBeforeChildren(MouseEvent event, Vector3d ptView, Vector3d vView, Vector3d ptViewLocal, Vector3d vViewLocal) {
		//System.out.printf("ptView: (%f, %f, %f)\n", ptViewLocal.x, ptViewLocal.y, ptViewLocal.z);
		//System.out.printf("vView: (%f, %f, %f)\n", vViewLocal.x, vViewLocal.y, vViewLocal.z);
		return false;
	}
}

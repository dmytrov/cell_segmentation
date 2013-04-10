//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import java.util.ArrayList;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;

public class SceneLayer3D extends SceneLayer {

	public ArrayList<IRenderable> renderables;
	
	public SceneLayer3D(String name, SceneLayer parentLayer) {
		super(name, parentLayer);
		renderables = new ArrayList<IRenderable>(); 
	}
	
	public void setupMaterials(GL gl)
	{
        float[] rgb = {0.3f, 0.5f, 0.5f};
        float[] rgbSpec = {1.0f, 1.0f, 1.0f};
        gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT, rgb, 0);
        gl.glMaterialfv(GL.GL_FRONT, GL.GL_DIFFUSE, rgb, 0);
        gl.glMaterialfv(GL.GL_FRONT, GL.GL_SPECULAR, rgbSpec, 0);
        gl.glMaterialf(GL.GL_FRONT, GL.GL_SHININESS, 20.0f);
	}

	@Override
	public void renderAfterChildren(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		setupMaterials(gl);
		gl.glBegin(GL.GL_TRIANGLES);
        gl.glColor3f(1.0f, 0.0f, 0.0f); gl.glNormal3d(0.0f, 0.0f, 1.0f); gl.glVertex3f(-1.0f, 0.0f, 1.0f);
        gl.glColor3f(0.0f, 1.0f, 0.0f); gl.glNormal3d(0.0f, 0.0f, 1.0f); gl.glVertex3f( 0.0f, 1.0f, 1.0f);
        gl.glColor3f(0.0f, 0.0f, 1.0f); gl.glNormal3d(0.0f, 0.0f, 1.0f); gl.glVertex3f( 1.0f, 0.0f, 1.0f);
        gl.glEnd();               
		for (IRenderable renderable : renderables ) {
			renderable.render(drawable);
		}			
	}
	
}

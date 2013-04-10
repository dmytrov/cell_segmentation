//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;


public class SceneLayerLight extends SceneLayer {
	public static float SHINE_ALL_DIRECTIONS = 1;
	public float[] lightPos = {-50, 100, 20, SHINE_ALL_DIRECTIONS};
	public float[] lightColorAmbient = {0.1f, 0.1f, 0.2f, 1f};
	public float[] lightColorDiffuse = {0.8f, 0.8f, 0.8f, 1f};
	public float[] lightColorSpecular = {1.0f, 1.0f, 1.0f, 1f};

	public SceneLayerLight(String name, SceneLayer parentLayer) {
		super(name, parentLayer);
	}
	
	public void setupLight(GL gl)
	{
        // Enable lighting
        gl.glEnable(GL.GL_LIGHTING);
        gl.glEnable(GL.GL_LIGHT1);

        // Setup the lights
        gl.glLightfv(GL.GL_LIGHT1, GL.GL_POSITION, lightPos, 0);
        gl.glLightfv(GL.GL_LIGHT1, GL.GL_AMBIENT, lightColorAmbient, 0);
        gl.glLightfv(GL.GL_LIGHT1, GL.GL_DIFFUSE, lightColorDiffuse, 0);
        gl.glLightfv(GL.GL_LIGHT1, GL.GL_SPECULAR, lightColorSpecular, 0);
	}

	@Override
	public void renderBeforeChildren(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		setupLight(gl);
	}	
}

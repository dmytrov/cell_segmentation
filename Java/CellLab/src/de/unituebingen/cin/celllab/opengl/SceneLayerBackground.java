package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;

public class SceneLayerBackground extends SceneLayer {
	
	public SceneLayerBackground(String name, SceneLayer parentLayer) {
		super(name, parentLayer);
	}

	public void renderBeforeChildren(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		
		Camera.pushProjection(gl);
		Camera.setOrthogonalProjection(drawable);		
		
		gl.glMatrixMode(GL.GL_MODELVIEW);
		gl.glLoadIdentity();
		
		gl.glClear( GL.GL_COLOR_BUFFER_BIT );
        gl.glBegin(GL.GL_POLYGON);
        gl.glColor3f(0.8f, 0.9f, 0.8f); gl.glVertex2f(0, 0);
        gl.glColor3f(0.9f, 0.9f, 0.9f); gl.glVertex2f(0, drawable.getHeight());
        gl.glColor3f(0.9f, 0.9f, 0.9f); gl.glVertex2f(drawable.getWidth(), drawable.getHeight());
        gl.glColor3f(0.8f, 0.9f, 1.0f); gl.glVertex2f(drawable.getWidth(), 0);
        gl.glEnd();
        
        Camera.popProjection(gl);
        
        gl.glClearDepth(1.0f);      
	    gl.glEnable(GL.GL_DEPTH_TEST); 
	    gl.glDepthFunc(GL.GL_LEQUAL);  
	    gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST); 
	    gl.glShadeModel(GL.GL_SMOOTH); 
	    gl.glClear(GL.GL_DEPTH_BUFFER_BIT);
        
	}
}

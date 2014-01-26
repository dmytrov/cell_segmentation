//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GL;
import javax.media.opengl.GL2;
import javax.media.opengl.GLAutoDrawable;

public class SceneLayerBackground extends SceneLayer {
	
	public SceneLayerBackground(String name, SceneLayer parentLayer) {
		super(name, parentLayer);
	}

	public void renderBeforeChildren(GLAutoDrawable drawable) {
		GL2 gl = drawable.getGL().getGL2();
		
		gl.glClearDepth(1.0f);      
	    gl.glEnable(GL.GL_DEPTH_TEST); 
	    gl.glDepthFunc(GL.GL_LEQUAL);  
	    gl.glHint(GL2.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST); 
	    gl.glShadeModel(GL2.GL_SMOOTH); 
	    gl.glClear(GL.GL_DEPTH_BUFFER_BIT);
	    
		Camera.pushProjection(gl);
		Camera.setOrthogonalProjection(drawable);		
		
		gl.glDisable(GL2.GL_LIGHTING);
		
		gl.glMatrixMode(GL2.GL_MODELVIEW);
		gl.glLoadIdentity();

		gl.glClear(GL.GL_COLOR_BUFFER_BIT);
        gl.glBegin(GL2.GL_POLYGON);
        gl.glColor3f(0.8f, 0.9f, 1.0f); gl.glVertex2f(0, 0);
        gl.glColor3f(0.9f, 0.9f, 0.9f); gl.glVertex2f(0, drawable.getHeight());
        gl.glColor3f(0.9f, 0.9f, 0.9f); gl.glVertex2f(drawable.getWidth(), drawable.getHeight());
        gl.glColor3f(0.7f, 0.8f, 0.9f); gl.glVertex2f(drawable.getWidth(), 0);
        gl.glEnd();
        
        Camera.popProjection(gl);
        
        gl.glClearDepth(1.0f);      
	    gl.glEnable(GL.GL_DEPTH_TEST); 
	    gl.glDepthFunc(GL.GL_LEQUAL);  
	    gl.glHint(GL2.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST); 
	    gl.glShadeModel(GL2.GL_SMOOTH); 
	    gl.glClear(GL.GL_DEPTH_BUFFER_BIT);
	}
}

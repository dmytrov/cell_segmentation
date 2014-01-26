//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GL;
import javax.media.opengl.GL2;
import javax.media.opengl.GLAutoDrawable;
import javax.media.opengl.glu.GLU;
import de.unituebingen.cin.celllab.math.basic3d.*;

public class Camera {
	public int viewportX;
	public int viewportY;
	public int viewportWidth;
	public int viewportHeight;
	protected static GLU glu = new GLU();
	protected double[] mModelView;
	protected double[] mProjection;
	protected int[] mViewport;
	
	public Camera() {
		mModelView = new double[] {		1, 0, 0, 0, 
										0, 1, 0, 0,
										0, 0, 1, 0,
										0, 0, 0, 1 };
		
		mProjection = new double[] {	1, 0, 0, 0, 
										0, 1, 0, 0,
										0, 0, 1, 0,
										0, 0, 0, 1 };
		mViewport = new int[4]; 
	}
	
	public void reshape(GLAutoDrawable drawable, int x, int y, int width, int height) {
		viewportX = x;
		viewportY = y;
		viewportWidth = width;
		viewportHeight = height;
		
		GL2 gl = drawable.getGL().getGL2();
		
		setPerspectiveProjection(drawable, 45.0);
		        
        gl.glMatrixMode(GL2.GL_MODELVIEW);
        gl.glLoadIdentity();

        gl.glViewport(0, 0, viewportWidth, viewportHeight);
        
        // Read the OpenGL parameters back
        gl.glGetDoublev(GL2.GL_MODELVIEW_MATRIX, mModelView, 0);
        gl.glGetDoublev(GL2.GL_PROJECTION_MATRIX, mProjection, 0);
        gl.glGetIntegerv(GL.GL_VIEWPORT, mViewport, 0);
	}
	
	public Vector3d unProject(double x, double y) {
		double worldCoord[] = new double[4];
		int glY = mViewport[3] - (int) y - 1; // correct Y according to the OpenGL coordinates system
		glu.gluUnProject(x, glY, 0.0d, mModelView, 0, mProjection, 0, mViewport, 0, worldCoord, 0);
		Vector3d res = new Vector3d(worldCoord[0], worldCoord[1], worldCoord[2]);
		res.normalize();
		return res;
	}
	
	public static void pushProjection(GL2 gl) {
		gl.glMatrixMode(GL2.GL_PROJECTION);
		gl.glPushMatrix();
	}
	
	public static void popProjection(GL2 gl) {
		gl.glMatrixMode(GL2.GL_PROJECTION);
		gl.glPopMatrix();
	}
	
	public static void setPerspectiveProjection(GLAutoDrawable drawable, double fovAngle) {
		GL2 gl = drawable.getGL().getGL2();		
		gl.glMatrixMode(GL2.GL_PROJECTION);
		gl.glLoadIdentity();
		float aspect = (float)drawable.getWidth() / drawable.getHeight();
		float zNear = 0.1f;
		float zFar = 1000.0f;
		glu.gluPerspective(fovAngle, aspect, zNear, zFar);
	}
	
	public static void setOrthogonalProjection(GLAutoDrawable drawable) {
		GL2 gl = drawable.getGL().getGL2();		
		gl.glMatrixMode(GL2.GL_PROJECTION);
		gl.glLoadIdentity();
		glu.gluOrtho2D(0.0f, drawable.getWidth(), 0.0f, drawable.getHeight());		
	}
	
}

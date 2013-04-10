package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;

public class IndexMesh implements IRenderable {
	public double[][] vertices = new double[1][3];
	public double[][] normals = new double[1][3];
	public int[][] facets = new int[1][3];	
	public float[] color = new float[] {0.5f, 0.5f, 0.5f};
	public float[] colorFactorSelected = new float[] {0.5f, 0.5f, 2.0f};
	public int tag = 0;
	public boolean selected = false;
	
	public IndexMesh() {		
	}
	
	public IndexMesh(int nVertices, int nFacets) {
		vertices = new double[nVertices][3];
		normals =  new double[nVertices][3];
		facets = new int[nFacets][3];
	}
	
	@Override
	public void render(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		gl.glBegin(GL.GL_TRIANGLES);
		float[] colorCurrent = new float[3];
		System.arraycopy(color, 0, colorCurrent, 0, 3);
		if (selected) {
			for (int k = 0; k < colorCurrent.length; k++) {
				colorCurrent[k] = colorCurrent[k] * colorFactorSelected[k];
			}
		}
		gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT, colorCurrent, 0);
        gl.glMaterialfv(GL.GL_FRONT, GL.GL_SPECULAR, colorCurrent, 0);
        
        //gl.glColor3d(color[0], color[1], color[2]);
        double[] ve;
        double[] vn;
        for (int k = 0; k < facets.length; k++) {
        	int[] v = facets[k];
        	ve = vertices[v[0]];
        	vn = normals[v[0]];
        	gl.glNormal3d(vn[0], vn[1], vn[2]);
        	gl.glVertex3d(ve[0], ve[1], ve[2]);
        	ve = vertices[v[1]];
        	vn = normals[v[1]];
        	gl.glNormal3d(vn[0], vn[1], vn[2]);
        	gl.glVertex3d(ve[0], ve[1], ve[2]);
        	ve = vertices[v[2]];
        	vn = normals[v[2]];
        	gl.glNormal3d(vn[0], vn[1], vn[2]);
        	gl.glVertex3d(ve[0], ve[1], ve[2]);
        }
        gl.glEnd();
	}
}

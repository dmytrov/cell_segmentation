package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;

public class IndexMesh implements IRenderable {
	public double[][] vertices = new double[1][3];
	public double[][] normals = new double[1][3];
	public int[][] facets = new int[1][3];	
	public float[] colorAmbient = new float[] {1.0f, 1.0f, 1.0f, 1.0f};
	public float[] colorDiffuse = new float[] {1.0f, 1.0f, 1.0f, 1.0f};
	public float[] colorSpecular = new float[] {0.5f, 0.5f, 0.5f, 1.0f};
	public float[] colorFactor = new float[] {1.0f, 1.0f, 1.0f, 1.0f};
	public float[] colorFactorSelected = new float[] {2.0f, 2.0f, 2.0f, 1.0f};
	public float shininess = 20.0f;
	public int tag = 0;
	public boolean selected = false;
	public boolean visible = true;
	
	public IndexMesh() {		
	}
	
	public IndexMesh(int nVertices, int nFacets) {
		vertices = new double[nVertices][3];
		normals =  new double[nVertices][3];
		facets = new int[nFacets][3];
	}
	
	@Override
	public void render(GLAutoDrawable drawable) {
		if (!visible) {
			return;
		}
		GL gl = drawable.getGL();
		gl.glBegin(GL.GL_TRIANGLES);
		float[] colorAmbientCurrent = new float[4];
		float[] colorDiffuseCurrent = new float[4];
		float[] colorSpecularCurrent = new float[4];
		System.arraycopy(colorAmbient, 0, colorAmbientCurrent, 0, 4);
		System.arraycopy(colorDiffuse, 0, colorDiffuseCurrent, 0, 4);
		System.arraycopy(colorSpecular, 0, colorSpecularCurrent, 0, 4);
		for (int k = 0; k < 4; k++) {
			colorAmbientCurrent[k] = colorAmbientCurrent[k] * colorFactor[k];
			colorDiffuseCurrent[k] = colorDiffuseCurrent[k] * colorFactor[k];
			//colorSpecularCurrent[k] = colorSpecularCurrent[k] * colorFactor[k];
			if (selected) {					
				colorAmbientCurrent[k] = colorAmbientCurrent[k] * colorFactorSelected[k];
				colorDiffuseCurrent[k] = colorDiffuseCurrent[k] * colorFactorSelected[k];
				colorSpecularCurrent[k] = colorSpecularCurrent[k] * colorFactorSelected[k];
			}
		}
		gl.glMaterialfv(GL.GL_FRONT, GL.GL_AMBIENT, colorAmbientCurrent, 0);		
		gl.glMaterialfv(GL.GL_FRONT, GL.GL_DIFFUSE, colorDiffuseCurrent, 0);
        gl.glMaterialfv(GL.GL_FRONT, GL.GL_SPECULAR, colorSpecularCurrent, 0);
        gl.glMaterialf(GL.GL_FRONT, GL.GL_SHININESS, shininess);

        
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

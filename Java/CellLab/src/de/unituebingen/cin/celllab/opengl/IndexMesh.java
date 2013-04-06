package de.unituebingen.cin.celllab.opengl;

import java.util.ArrayList;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;

import de.unituebingen.cin.celllab.math.basic3d.*;

public class IndexMesh implements IRenderable {
	public double[][] vertices = new double[1][3];
	public int[][] facets = new int[1][3];
	public double[] color = new double[] {0.5, 0.5, 0.5};
	
	public IndexMesh() {		
	}
	
	public IndexMesh(int nVertices, int nFacets) {
		vertices = new double[nVertices][3];
		facets = new int[nFacets][3];
	}
	
	@Override
	public void render(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		gl.glBegin(GL.GL_TRIANGLES);
        gl.glColor3d(color[0], color[1], color[2]);
        double[] ve;
        for (int k = 0; k < facets.length; k++) {
        	int[] v = facets[k];
        	ve = vertices[v[0]];
        	gl.glVertex3d(ve[0], ve[1], ve[2]);
        	ve = vertices[v[1]];
        	gl.glVertex3d(ve[0], ve[1], ve[2]);
        	ve = vertices[v[2]];
        	gl.glVertex3d(ve[0], ve[1], ve[2]);
        }
        gl.glEnd();
	}
}

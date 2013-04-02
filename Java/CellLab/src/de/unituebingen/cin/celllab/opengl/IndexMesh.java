package de.unituebingen.cin.celllab.opengl;

import java.util.ArrayList;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;

import de.unituebingen.cin.celllab.math.basic3d.*;

public class IndexMesh implements IRenderable {
	public ArrayList<Vector3d> vertices;
	public ArrayList<Facet> facets;
	public double[] color = new double[] {0.5, 0.5, 0.5};
	
	public IndexMesh() {		
		vertices = new ArrayList<Vector3d>();
		facets = new ArrayList<Facet>();
	}
	
	public void AddVertex(double x, double y, double z) {
		vertices.add(new Vector3d(x, y, z));
	}
	
	public void AddFacet(int v1, int v2, int v3) {
		facets.add(new Facet(v1, v2, v3));
	}
	
	public class Facet {
		public int v1;
		public int v2;
		public int v3;
		
		public Facet() {
			this.v1 = -1;
			this.v2 = -1;
			this.v3 = -1;
		}		
		
		public Facet(int v1, int v2, int v3) {
			this.v1 = v1;
			this.v2 = v2;
			this.v3 = v3;
		}		
	}

	@Override
	public void render(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		gl.glBegin(GL.GL_TRIANGLES);
        gl.glColor3d(color[0], color[1], color[2]); 
        for (Facet facet : facets) {
        	Vector3d v = vertices.get(facet.v1);
        	gl.glVertex3d(v.x, v.y, v.z);
        	v = vertices.get(facet.v2);
        	gl.glVertex3d(v.x, v.y, v.z);
        	v = vertices.get(facet.v3);
        	gl.glVertex3d(v.x, v.y, v.z);        	
        }
        gl.glEnd();
	}
}

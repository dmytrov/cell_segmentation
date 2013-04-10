//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.math.basic3d;

@SuppressWarnings("serial")
public class Vector3d extends javax.vecmath.Vector3d {

	public Vector3d() {
		super();
	}
	
	public Vector3d(Vector3d pt) {
		super(pt);
	}

	public Vector3d(double x, double y, double z) {
		super(x, y, z);
	}
	
	public double[] toArray() {
		return new double[] {x, y, z};
	}

}
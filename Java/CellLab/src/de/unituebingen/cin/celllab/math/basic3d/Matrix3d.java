package de.unituebingen.cin.celllab.math.basic3d;

@SuppressWarnings("serial")
public class Matrix3d extends javax.vecmath.Matrix3d {

	public Matrix3d() {
		super();
	}
	
	public Matrix3d(Matrix3d m) {
		super(m);
	}
	
	public Vector3d mul(Vector3d v) {
		double r0 = m00*v.x + m01*v.y + m02*v.z;
		double r1 = m10*v.x + m11*v.y + m12*v.z;
		double r2 = m20*v.x + m21*v.y + m22*v.z;
		Vector3d res = new Vector3d(r0, r1, r2);
		return res;
	}
	
}

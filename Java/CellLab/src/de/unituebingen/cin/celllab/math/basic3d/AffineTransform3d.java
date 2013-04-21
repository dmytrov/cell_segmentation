//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.math.basic3d;

import de.unituebingen.cin.celllab.math.basic3d.Matrix3d;
import de.unituebingen.cin.celllab.math.basic3d.Vector3d;

public class AffineTransform3d {
	public Matrix3d rotation = new Matrix3d();
	public Vector3d translation = new Vector3d();
	
	public AffineTransform3d() {
		setIdentity();	
	}
	
	public AffineTransform3d(AffineTransform3d transform) {
		this.set(transform);
	}
	
	public double[][] getMatrix() {
		double[][] m = new double[4][4];
		m[0][0] = rotation.m00;
		m[0][1] = rotation.m01;
		m[0][2] = rotation.m02;
		m[0][3] = translation.x;
		m[1][0] = rotation.m10;
		m[1][1] = rotation.m11;
		m[1][2] = rotation.m12;
		m[1][3] = translation.y;
		m[2][0] = rotation.m20;
		m[2][1] = rotation.m21;
		m[2][2] = rotation.m22;
		m[2][3] = translation.z;
		m[3][0] = 0;
		m[3][1] = 0;
		m[3][2] = 0;
		m[3][3] = 1;
		return m;
	}
	
	public double[] getArray() {
		double[] m = new double[16];	
		m[0] = rotation.m00;
		m[1] = rotation.m10;
		m[2] = rotation.m20;
		m[3] = 0;
		m[4] = rotation.m01;
		m[5] = rotation.m11;
		m[6] = rotation.m21;
		m[7] = 0;
		m[8] = rotation.m02;
		m[9] = rotation.m12;
		m[10] = rotation.m22;
		m[11] = 0;
		m[12] = translation.x;
		m[13] = translation.y;
		m[14] = translation.z;
		m[15] = 1;
		
		return m;
	}
	
	public static AffineTransform3d combine(AffineTransform3d t1, AffineTransform3d t2) {
		AffineTransform3d res = new AffineTransform3d(t1);
		res.combine(t2);
		return res;
	}
	
	public void setIdentity() {
		rotation.setIdentity();
		translation.set(0d, 0d, 0d);
	}
	
	public Vector3d transformPoint(Vector3d pt) {
		Vector3d res = new Vector3d(pt);
		rotation.transform(res);
		res.add(translation);
		return res;
	}
	
	public Vector3d transformVector(Vector3d pt) {
		Vector3d res = new Vector3d(pt);
		rotation.transform(res);
		return res;
	}
	
	public void invert() {
		// For affine transform X' = AX + B its inverse is:
		// X = A'X' + B'
		// A' = A^-1
		// B' = -A^-1 * B
		// Because A is an orthogonal transformation, inverse is equal to transposed.
		rotation.transpose(); 
		translation = rotation.mul(translation);
		translation.negate();
	}
	
	public void invert(AffineTransform3d transform) {
		set(transform);
		invert();
	}
	
	public void set(AffineTransform3d transform) {
		rotation.set(transform.rotation);
		translation.set(transform.translation);
	}
	
	public void combine(AffineTransform3d transform) {
		Matrix3d newRotation = new Matrix3d();
		newRotation.mul(this.rotation, transform.rotation);
		Vector3d newTranslation = this.rotation.mul(transform.translation);
		newTranslation.add(this.translation);
		this.rotation.set(newRotation);
		this.translation.set(newTranslation);
	}
	
}










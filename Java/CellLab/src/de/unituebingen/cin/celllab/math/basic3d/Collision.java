package de.unituebingen.cin.celllab.math.basic3d;

public class Collision {
	public static Vector3d VectorPlaneIntersect(Vector3d ptVec, Vector3d vVec, Vector3d ptPlane, Vector3d vnPlane) {
		Vector3d ptIntersect = new Vector3d(Double.NaN, Double.NaN, Double.NaN);
		boolean bIntersect = (vnPlane.dot(vVec)) != 0;
		if (bIntersect) {
			double k = vnPlane.dot(ptPlane.minus(ptVec)) / (vnPlane.dot(vVec));
		    ptIntersect = ptVec.plus(vVec.mult(k));
		}
		return ptIntersect;
	}
}

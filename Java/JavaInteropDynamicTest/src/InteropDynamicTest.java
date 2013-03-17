
public class InteropDynamicTest {
	public InteropDynamicTest() {
		
	}
	
	public int callInt(int i) {
		System.out.printf("callInt: %d\n", i);
		return i;
	}
	
	public String callString(String s) {
		System.out.printf("callInt: %s\n", s);
		return s + s;
	}
	
	public void callObject(Object obj) {
		System.out.printf("callObject: %s\n", obj.toString());
	}
	
	public double[] callVector(double[] v) {
		System.out.printf("callVector: %s\n", v.toString());
		return v;
	}
	
	public double[][] callMatrix(double[][] m) {
		System.out.printf("callMatrix: %s\n", m.toString());
		return m;
	}
	
	public double[][] callMultMatrix(double[][] m, double q) {
		System.out.printf("callMultMatrix: %s\n", m.toString());
		for (int k1 = 0; k1<m.length; k1++) {
			for (int k2 = 0; k2<m[0].length; k2++) {
				m[k1][k2] = q * m[k1][k2]; 
			}
		}		
		return m;
	}
	
	public double[][][] callMultStack(double[][][] m, double q) {
		System.out.printf("callMultStack: %s\n", m.toString());
		for (int k1 = 0; k1<m.length; k1++) {
			for (int k2 = 0; k2<m[0].length; k2++) {
				for (int k3 = 0; k3<m[0][0].length; k3++) {
					m[k1][k2][k3] = q * m[k1][k2][k3]; 
				}
			}
		}		
		return m;
	}
}

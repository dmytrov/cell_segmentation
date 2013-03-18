
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
	
	////////////////////////////////////////////////////////////////////////////////////
	//						Events test
	////////////////////////////////////////////////////////////////////////////////////
	
	// Internal class definition
    public class MyTestEvent2 extends java.util.EventObject {
        private static final long serialVersionUID = 1L;
        public float oldValue, newValue;        
        
        MyTestEvent2(Object obj, float oldValue, float newValue) {
            super(obj);
            this.oldValue = oldValue;
            this.newValue = newValue;
        }
    }
    
    // Internal interface definition
    public interface MyTestListener2 extends java.util.EventListener {
        void testEvent(MyTestEvent2 event); //  visible to matlab as TestEventCallback
    }

    private java.util.Vector<MyTestListener2> listeners = new java.util.Vector<MyTestListener2>();	   
    
    // Add an event subscription. Used by matlab
    public synchronized void addMyTestListener2(MyTestListener2 lis) {
        listeners.addElement(lis);
    }
    
    // Remove the event subscription. Used by matlab
    public synchronized void removeMyTestListener2(MyTestListener2 lis) {
        listeners.removeElement(lis);
    }
    
    @SuppressWarnings("unchecked")
	public void notifyMyTest() {
        java.util.Vector<MyTestListener2> listenersCopy;
        synchronized(this) {
            listenersCopy = (java.util.Vector<MyTestListener2>)listeners.clone();
        }
        for (int i=0; i<listenersCopy.size(); i++) {
            MyTestEvent2 event = new MyTestEvent2(this, 0, 1);
            ((MyTestListener2)listenersCopy.elementAt(i)).testEvent(event);
        }
    }
}

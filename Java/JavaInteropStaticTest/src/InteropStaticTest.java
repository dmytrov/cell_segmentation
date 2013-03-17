public class InteropStaticTest
{
	// Internal class definition
    public class MyTestEvent extends java.util.EventObject {
        private static final long serialVersionUID = 1L;
        public float oldValue, newValue;        
        
        MyTestEvent(Object obj, float oldValue, float newValue) {
            super(obj);
            this.oldValue = oldValue;
            this.newValue = newValue;
        }
    }
    
    // Internal interface definition
    public interface MyTestListener extends java.util.EventListener {
        void testEvent(MyTestEvent event); //  visible to matlab as TestEventCallback
    }

    private java.util.Vector<MyTestListener> listeners = new java.util.Vector<MyTestListener>();
	
    public InteropStaticTest() {
    	int k = 3;
    	System.out.printf("InteropTest constructor, parameter %d /n", k);
    }
    
    // Add an event subscription. Used by matlab
    public synchronized void addMyTestListener(MyTestListener lis) {
        listeners.addElement(lis);
    }
    
    // Remove the event subscription. Used by matlab
    public synchronized void removeMyTestListener(MyTestListener lis) {
        listeners.removeElement(lis);
    }
    
    @SuppressWarnings("unchecked")
	public void notifyMyTest() {
        java.util.Vector<MyTestListener> dataCopy;
        synchronized(this) {
            dataCopy = (java.util.Vector<MyTestListener>)listeners.clone();
        }
        for (int i=0; i<dataCopy.size(); i++) {
            MyTestEvent event = new MyTestEvent(this, 0, 1);
            ((MyTestListener)dataCopy.elementAt(i)).testEvent(event);
        }
    }
}
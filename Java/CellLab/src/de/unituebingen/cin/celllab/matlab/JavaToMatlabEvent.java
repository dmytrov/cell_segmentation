package de.unituebingen.cin.celllab.matlab;

public abstract class JavaToMatlabEvent<T> extends java.util.EventObject {
	private static final long serialVersionUID = 1L;
	public T data;
	public EventResultHandler<T> eventResultHandler;

	public JavaToMatlabEvent(Object source, T intiData, EventResultHandler<T> erh) {
		super(source);
		data = intiData;
		eventResultHandler = erh;
		if (eventResultHandler != null) {
			eventResultHandler.onInit(data);
		}
	}

	public void onHandled() {
		if (eventResultHandler != null) {			
			eventResultHandler.onHandled(data);
			eventResultHandler.notifyHandled();
		}
	}
	
	public void waitUntilHandled() throws InterruptedException {
		if (eventResultHandler != null) {
			eventResultHandler.waitUntilHandled();
		}
	}
	
	public void waitUntilHandledCatchExceptions() {
		if (eventResultHandler != null) {
			eventResultHandler.waitUntilHandledCatchExceptions();			
		}
	}
}
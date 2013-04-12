package de.unituebingen.cin.celllab.matlab;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

public class EventResultHandler<T> {
	private final ReentrantLock lock = new ReentrantLock();
	private final Condition notHandled = lock.newCondition();
	private boolean handled = false;
	
	public void notifyHandled() {
		lock.lock();
		try {
			handled = true;
			notHandled.signal();
		} finally {
			lock.unlock();
		}
	}
	
	public void waitUntilHandled() throws InterruptedException {
		lock.lock();
		try {
			while (!handled) {
				notHandled.await();
			}
		} finally {
			lock.unlock();
		}				
	}
	
	public void waitUntilHandledCatchExceptions() {
		try {
			waitUntilHandled();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
	
	public void onInit(T data) {		
	}
	
	public void onHandled(T data) {		
	}
	
	
}
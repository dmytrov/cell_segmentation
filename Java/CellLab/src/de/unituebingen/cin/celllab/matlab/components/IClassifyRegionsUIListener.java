package de.unituebingen.cin.celllab.matlab.components;

import java.util.EventObject;

import de.unituebingen.cin.celllab.matlab.EventResultHandler;
import de.unituebingen.cin.celllab.matlab.JavaToMatlabEvent;

public interface IClassifyRegionsUIListener extends java.util.EventListener{
	
	public class EmptyEventData {
	}
	
	public class EmptyResultHandler extends EventResultHandler<EmptyEventData> {		
	}
	
	public class EmptyEvent extends JavaToMatlabEvent<EmptyEventData> {
		private static final long serialVersionUID = 1L;
        public EmptyEvent(Object source) {
            super(source, new EmptyEventData(), new EmptyResultHandler());
        }
	}
	
	public class SynchronousResultHandler extends EventResultHandler<EmptyEventData> {
		public boolean handled = false;
		@Override
		public void onHandled(EmptyEventData data) {
			handled = true;
			this.notify();
		}
	}
	
	public class SynchronousEvent extends JavaToMatlabEvent<EmptyEventData> {
        private static final long serialVersionUID = 1L;
        
        public SynchronousEvent(Object source) {
            super(source, new EmptyEventData(), new SynchronousResultHandler());
        }
        
        public SynchronousEvent(Object source, SynchronousResultHandler erh) {
            super(source, new EmptyEventData(), erh);
        }
        
        public void waitUntilHandled() {        	
        	SynchronousResultHandler erh = (SynchronousResultHandler)eventResultHandler;
			try {
				synchronized (erh) {
					while (!erh.handled) {
							erh.wait();
					}
				}
			} catch (InterruptedException e) {
					e.printStackTrace();
			}
        }
    }
	
	void autoClassify(EventObject event);
	void getRegionByRay(EventObject event);
	void markRegion(EventObject event);
	void cutRegion(EventObject event);
}

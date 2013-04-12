package de.unituebingen.cin.celllab.matlab.components;

import java.util.EventObject;

import de.unituebingen.cin.celllab.matlab.EventResultHandler;
import de.unituebingen.cin.celllab.matlab.JavaToMatlabEvent;

public interface IClassifyRegionsUIListener extends java.util.EventListener{
	
	public class AutoClassifyEventData {
	}
	
	public class AutoClassifyResultHandler extends EventResultHandler<AutoClassifyEventData> {		
	}
	
	public class AutoClassifyEvent extends JavaToMatlabEvent<AutoClassifyEventData> {
		private static final long serialVersionUID = 1L;
        public AutoClassifyEvent(Object source) {
            super(source, new AutoClassifyEventData(), new AutoClassifyResultHandler());
        }
	}	
	
	void autoClassify(EventObject event);
	
	//-------------------------------------------------------------------------------
	public class GetRegionByRayEventData {
		public double[] ptRay;
		public double[] vRay;
		public int kSelected = -1;
	}
	
	public class GetRegionByRayResultHandler extends 
				EventResultHandler<GetRegionByRayEventData>{		
	}
	
	public class GetRegionByRayEvent extends JavaToMatlabEvent<GetRegionByRayEventData> {
		private static final long serialVersionUID = 1L;

		public GetRegionByRayEvent(Object source, GetRegionByRayResultHandler erh) {
			super(source, new GetRegionByRayEventData(), erh);
		}
	}
	
	void getRegionByRay(GetRegionByRayEvent event);
	
	//-------------------------------------------------------------------------------
	void markRegion(EventObject event);
	void cutRegion(EventObject event);
}

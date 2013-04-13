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
	public class MarkRegionEventData {
		public int regionID;
		public int newMark;
	}
	
	public class MarkRegionResultHandler extends 
				EventResultHandler<MarkRegionEventData>{		
	}
	
	public class MarkRegionEvent extends JavaToMatlabEvent<MarkRegionEventData> {
		private static final long serialVersionUID = 1L;

		public MarkRegionEvent(Object source, MarkRegionResultHandler erh) {
			super(source, new MarkRegionEventData(), erh);
		}
	}
	
	void markRegion(MarkRegionEvent event);
	
	// -------------------------------------------------------------------------------
	public class DeleteRegionEventData {
		public int regionID;
	}

	public class DeleteRegionResultHandler extends
			EventResultHandler<DeleteRegionEventData> {
	}

	public class DeleteRegionEvent extends
			JavaToMatlabEvent<DeleteRegionEventData> {
		private static final long serialVersionUID = 1L;

		public DeleteRegionEvent(Object source, DeleteRegionResultHandler erh) {
			super(source, new DeleteRegionEventData(), erh);
		}
	}

	void deleteRegion(DeleteRegionEvent event);
	
	//-------------------------------------------------------------------------------
	public class CutRegionEventData {
		public int regionID;
		public double[] ptPlane;
		public double[] vnPlane;
	}
	
	public class CutRegionResultHandler extends 
				EventResultHandler<CutRegionEventData>{		
	}
	
	public class CutRegionEvent extends JavaToMatlabEvent<CutRegionEventData> {
		private static final long serialVersionUID = 1L;

		public CutRegionEvent(Object source, CutRegionResultHandler erh) {
			super(source, new CutRegionEventData(), erh);
		}
	}
	
	void cutRegion(CutRegionEvent event);
}

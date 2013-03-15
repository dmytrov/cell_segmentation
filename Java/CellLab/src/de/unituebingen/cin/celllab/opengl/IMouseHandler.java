//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import java.awt.event.MouseEvent;
import de.unituebingen.cin.celllab.math.basic3d.*;

public interface IMouseHandler {
	//void focusLost();
	boolean handleMouseMove(MouseEvent event, Vector3d ptView, Vector3d vView);
	boolean handleMousePressed(MouseEvent event, Vector3d ptView, Vector3d vView);
	boolean handleMouseReleased(MouseEvent event, Vector3d ptView, Vector3d vView);
	
}

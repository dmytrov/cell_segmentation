//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

import java.awt.BorderLayout;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.media.opengl.GLJPanel;
import javax.swing.JFrame;
import de.unituebingen.cin.celllab.*;
import de.unituebingen.cin.celllab.opengl.*;

public class CellLabApplication
{
	static boolean ExitOnClose = false;
	
	@SuppressWarnings("unused")
	public static void main(String[] args)
 	{
		final JFrame jFrame = new JFrame( "CellLab OpenGL window" ); 
        jFrame.addWindowListener( new WindowAdapter() {
            public void windowClosing( WindowEvent windowevent ) {
                jFrame.dispose();
                if (ExitOnClose) {
                	System.exit( 0 );
                }
            }
        });
        
		GLJPanel glPanel = GLRendererFactory.MakeUIRenderer();
		SceneLayer sceneRoot = new SceneLayer("Root", null);
		SceneLayer sceneMouseRot = new SceneLayerMouseRotationControl("Mouse rotation", sceneRoot);
		sceneMouseRot.transform.translation.z = -10;		
		SceneLayer scene3D = new SceneLayer3D("3D", sceneMouseRot);
		scene3D.transform.translation.x = 0; 
		scene3D.transform.translation.y = 0;
		scene3D.transform.translation.z = 0;
		SceneLayer sceneBackground = new SceneLayerBackground("Background", sceneRoot);
		Controller controller = new Controller();
		controller.attachScene(sceneRoot);
		controller.attachRenderer(glPanel);
		controller.attachUIComponent(glPanel);
		
		jFrame.getContentPane().add(glPanel, BorderLayout.CENTER);
        jFrame.setSize(640, 480);
        jFrame.setVisible(true);
 	}
}

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
		SceneLayer scene3D = new SceneLayer3D("3D", sceneRoot);
		SceneLayer sceneBackground = new SceneLayerBackground("Background", sceneRoot);
		Controller controller = new Controller();
		controller.attachScene(sceneRoot);
		controller.attachRenderer(glPanel);
		controller.attachUIComponent(glPanel);
		
		jFrame.getContentPane().add( glPanel, BorderLayout.CENTER );
        jFrame.setSize( 640, 480 );
        jFrame.setVisible( true );
        
		System.out.println("Test OK!");
 	}
}
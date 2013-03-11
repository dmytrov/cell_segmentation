import javax.media.opengl.GLAutoDrawable;
import javax.media.opengl.GLEventListener;
import javax.media.opengl.GLCapabilities;
import javax.media.opengl.GLCanvas;

import java.awt.Frame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

/**
 * A minimal program that draws with JOGL in an AWT Frame.
 *
 * @author Wade Walker
 * 
 * History:
 * 		Dmytro Velychko (2013.03.11) - adapted to JOGL v1.1.1
 */
public class OneTriangleAWT {

	public static boolean ExitOnClose = false;
	
    public static void main_( String [] args ) {
        GLCapabilities glcapabilities = new GLCapabilities();
        glcapabilities.setDoubleBuffered(true);
        final GLCanvas glcanvas = new GLCanvas( glcapabilities );

        glcanvas.addGLEventListener( new GLEventListener() {
            
            @Override
            public void reshape( GLAutoDrawable glautodrawable, int x, int y, int width, int height ) {
                OneTriangle.setup( glautodrawable.getGL(), width, height );
            }
            
            @Override
            public void init( GLAutoDrawable glautodrawable ) {
            }                      
            
            @Override
            public void display( GLAutoDrawable glautodrawable ) {
                OneTriangle.render( glautodrawable.getGL(), glautodrawable.getWidth(), glautodrawable.getHeight() );
            }
            
            @Override
            public void displayChanged(GLAutoDrawable drawable, boolean modeChanged,
            	      boolean deviceChanged)
            {
            }
        });

        final Frame frame = new Frame( "One Triangle AWT" );
        frame.add( glcanvas );
        frame.addWindowListener( new WindowAdapter() {
            public void windowClosing( WindowEvent windowevent ) {
                frame.remove( glcanvas );
                frame.dispose();
                if (ExitOnClose) {
                	System.exit( 0 );
                }
            }
        });

        frame.setSize( 640, 480 );
        frame.setVisible( true );
    }
}
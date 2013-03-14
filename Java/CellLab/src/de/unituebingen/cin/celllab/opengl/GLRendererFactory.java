package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GLCapabilities;
import javax.media.opengl.GLJPanel;

public class GLRendererFactory {
	
	public static GLJPanel MakeUIRenderer()
	{
		GLCapabilities glCapabilities = new GLCapabilities();
        glCapabilities.setDoubleBuffered(true);
        return new GLJPanel(glCapabilities);
	}

}

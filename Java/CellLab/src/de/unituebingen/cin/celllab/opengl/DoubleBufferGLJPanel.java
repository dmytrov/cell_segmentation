package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GLCapabilities;
import javax.media.opengl.GLJPanel;

public class DoubleBufferGLJPanel extends GLJPanel{
	private static final long serialVersionUID = 1L;
	private static GLCapabilities glCapabilities;
	static {
		glCapabilities = new GLCapabilities();
		glCapabilities.setDoubleBuffered(true);
	}
	
	public DoubleBufferGLJPanel() {
		super(glCapabilities);
	}
}

package de.unituebingen.cin.celllab.opengl;

import java.awt.AWTEvent;

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
		this.enableEvents(AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK | AWTEvent.MOUSE_WHEEL_EVENT_MASK);
	}
}

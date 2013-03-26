//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GLJPanel;

public class GLRendererFactory {
	
	public static GLJPanel MakeUIRenderer()
	{
        return new DoubleBufferGLJPanel();
	}

}

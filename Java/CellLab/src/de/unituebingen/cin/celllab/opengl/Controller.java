//	History:
//		Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
//		mailto:dmytro.velychko@student.uni-tuebingen.de

package de.unituebingen.cin.celllab.opengl;

import javax.media.opengl.GLAutoDrawable;
import javax.media.opengl.GLEventListener;

import de.unituebingen.cin.celllab.math.basic3d.*;

import java.awt.Component;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

public class Controller implements GLEventListener, MouseListener, MouseMotionListener, MouseWheelListener, KeyListener  {
	protected SceneLayer scene;
	protected GLAutoDrawable drawable; // GLEvents producer
	protected Component component;	// UI component
	public Camera camera; 
	
	public Controller()
	{
		camera = new Camera();
	}
	
	public void attachScene(SceneLayer scene)
	{
		this.scene = scene;
	}
	
	public void attachRenderer(GLAutoDrawable drawable)
	{
		this.drawable = drawable; 
		drawable.addGLEventListener(this);
	}
	
	public void attachUIComponent(Component component)
	{
		this.component = component;
		component.addMouseListener(this);
		component.addMouseWheelListener(this);
		component.addMouseMotionListener(this);
		component.addKeyListener(this);
	}
	
	public void invalidateScene()
	{
		// Asynchronouns call to invoke rendering
		if (component != null) {
			component.repaint();
		}
	}
	
	// GLEventListener implementation
	@Override
    public void reshape( GLAutoDrawable drawable, int x, int y, int width, int height ) {
		camera.reshape(drawable, x, y, width, height);		
    }
    
    @Override
    public void init( GLAutoDrawable drawable ) {
    }
    
    @Override
    public void display( GLAutoDrawable drawable ) {
    	if (scene != null) {
    		scene.render(drawable);
    	}        
    }
    
    @Override
    public void displayChanged(GLAutoDrawable drawable, boolean modeChanged, boolean deviceChanged) {
    }

 	// MouseListener implementation
	@Override
	public void mousePressed(MouseEvent e) {
		if (component != null) {
			component.requestFocus();
		}
		if (scene != null) {
			Vector3d ptView = new Vector3d(0d, 0d ,0d);
			Vector3d vView = camera.unProject(e.getX(), e.getY());
    		scene.handleMousePressed(e, ptView, vView);
    	} 
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		if (scene != null) {
			Vector3d ptView = new Vector3d(0d, 0d ,0d);
			Vector3d vView = camera.unProject(e.getX(), e.getY());
    		scene.handleMouseReleased(e, ptView, vView);
    	}
	}

	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}
    
	// MouseWheelListener implementation
	@Override
	public void mouseWheelMoved(MouseWheelEvent e) {
		if (scene != null) {
			Vector3d ptView = new Vector3d(0d, 0d ,0d);
			Vector3d vView = camera.unProject(e.getX(), e.getY());
			scene.handleMouseWheelMoved(e, ptView, vView);
		}
	}

	@Override
	public void mouseClicked(MouseEvent e) {
		if (component != null) {
			component.requestFocus();
		}
	}

	@Override
	public void mouseDragged(MouseEvent e) {
		mouseMoved(e);		
	}

	@Override
	public void mouseMoved(MouseEvent e) {
		if (scene != null) {
			Vector3d ptView = new Vector3d(0d, 0d ,0d);
			Vector3d vView = camera.unProject(e.getX(), e.getY());
    		scene.handleMouseMove(e, ptView, vView);
    	}		
	}

	// KeyListener implementation
	@Override
	public void keyPressed(KeyEvent e) {
		if (scene != null) {
			scene.handleKeyPressed(e);
		}
	}

	@Override
	public void keyReleased(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void keyTyped(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}
    
}

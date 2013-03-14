package de.unituebingen.cin.celllab;

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;
import javax.media.opengl.GLEventListener;
import javax.media.opengl.glu.GLU;

import de.unituebingen.cin.celllab.math.basic3d.*;
import de.unituebingen.cin.celllab.opengl.*;

import java.awt.Component;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;

public class Controller implements GLEventListener, MouseListener, MouseWheelListener {
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
		if (scene != null) {
			Vector3d ptView = new Vector3d(0d, 0d ,0d);
			Vector3d vView = camera.unProject(e.getX(), e.getY());
    		scene.handleMousePressed(e, ptView, vView);
    	} 
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
		
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
		// TODO Auto-generated method stub

	}

	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub

	}


    
    
}

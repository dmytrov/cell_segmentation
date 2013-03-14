package de.unituebingen.cin.celllab.opengl;

import java.awt.event.MouseEvent;
import java.util.*;
import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;
import de.unituebingen.cin.celllab.math.basic3d.*;

public class SceneLayer implements IRenderable, IMouseHandler {
	public String name;
	protected SceneLayer parentLayer = null;
	public List<SceneLayer> childLayers = new ArrayList<SceneLayer>();
	protected SceneLayer focusedLayer = null;
	protected AffineTransform3d transform = new AffineTransform3d();
	
	public SceneLayer(String name, SceneLayer parentLayer) {
		this.parentLayer = parentLayer;
		this.name = name;
		if (parentLayer != null) {
			parentLayer.childLayers.add(this);
		}
	}
	
	public void render(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		gl.glMatrixMode(GL.GL_MODELVIEW);
		gl.glPushMatrix();
		gl.glLoadMatrixd(transform.getArray(), 0);
		renderBeforeChildren(drawable);
		renderChildrenReverseOrder(drawable);
		renderAfterChildren(drawable);
		
		gl.glMatrixMode(GL.GL_MODELVIEW);
		gl.glPopMatrix();
	}
	
	public void renderBeforeChildren(GLAutoDrawable drawable) {
		
	}		
	
	public void renderChildrenReverseOrder(GLAutoDrawable drawable){
		for (int i = childLayers.size()-1; i >= 0; i--) {
			childLayers.get(i).render(drawable);
		}
	}
	
	public void renderAfterChildren(GLAutoDrawable drawable) {
		
	}
	
	protected AffineTransform3d getFullTransform() {
		AffineTransform3d res = new AffineTransform3d();
		if (parentLayer != null) {
			res.set(parentLayer.getFullTransform());
		}
		res.combine(this.transform);
		return res;
	}
	
	public boolean handleMouseMove(MouseEvent event, Vector3d ptView, Vector3d vView) {
		//Matrix3d transformInv = getTransformInv();
		for (SceneLayer childLayer : childLayers) {
			if (childLayer.handleMouseMove(event, ptView, vView)) {
				return true;
			}			
		}
		return false;
	}
	
	public boolean handleMousePressed(MouseEvent event, Vector3d ptView, Vector3d vView) {
		for (SceneLayer childLayer : childLayers) {
			if (childLayer.handleMousePressed(event, ptView, vView)) {
				return true;
			}			
		}
		return false;
	}
	
	public boolean handleMouseReleased(MouseEvent event, Vector3d ptView, Vector3d vView) {
		for (SceneLayer childLayer : childLayers) {
			if (childLayer.handleMouseReleased(event,ptView, vView)) {
				return true;
			}			
		}
		return false;
	}

}







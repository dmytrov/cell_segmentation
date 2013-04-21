package de.unituebingen.cin.celllab.matlab.components;

import java.awt.AWTEvent;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;

import javax.swing.JComponent;

public class JStackViewer extends JComponent {
	private static final long serialVersionUID = 1L;
	protected int[][][] stack = new int[64][64][4];
	protected int[][][] overlay = new int[64][64][4];
	protected float[][] overlayColorFactor = new float[1][3]; // array Nx3
	public enum Axis {
		X,
		Y,
		Z
	}
	protected Axis axis = Axis.Z;
	protected int slice = 0;
	protected int maxIntensity = 32;
	
	public JStackViewer() {
		this.enableEvents(AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK);
	}
	
	protected float[][] matrixCopy(float[][] src) {
		if (src == null) {
			return new float[1][1];
		}
		float[][] res = new float[src.length][src[0].length];
		for (int k = 0; k<src.length; k++) {
			System.arraycopy(src[k], 0, res[k], 0, src[k].length);
		}
		return res;
	}
	
	protected int[][][] stackCopy(int[][][] src) {
		if (src == null) {
			return new int[1][1][1];
		}
		int[][][] res = new int[src.length][src[0].length][src[0][0].length];
		for (int k1 = 0; k1<src.length; k1++) {
			for (int k2 = 0; k2<src.length; k2++) {
				System.arraycopy(src[k1][k2], 0, res[k1][k2], 0, src[k1][k2].length);
			}
		}
		return res;
	}
	
	public int[][][] getStack() {
		return stackCopy(stack);
	}
	
	public void setStack(int[][][] m) {
		stack = stackCopy(m);
		repaint();
	}
	
	public int[][][] getOverlay() {
		return stackCopy(overlay);
	}
	
	public void setOverlay(int[][][] m) {
		overlay = stackCopy(m);
		repaint();
	}
	
	public float[][] getOverlayColorFactor() {
		return matrixCopy(overlayColorFactor);
	}
	
	public void setOverlayColorFactor(float[][] m) {
		overlayColorFactor = matrixCopy(m);
		repaint();
	}
	
	public Axis getAxis() {
		return axis;
	}
	
	public void setAxis(Axis newAxis) {
		axis = newAxis;
		repaint();
	}
	
	public int getSlice() {
		return slice;
	}
	
	public void setSlice(int newSlice) {
		slice = newSlice;
		repaint();
	}
	
	public void setMaxIntensity(int newMaxIntensity) {
		maxIntensity = newMaxIntensity;
		repaint();
	}
	
	protected int[][] makeSlice(int[][][] buffer, Axis aDir, int kSlice) {
		int[][] res = null;
		int sx = buffer.length;
		int sy = buffer[0].length;
		int sz = buffer[0][0].length;
		int[] size = new int[] {sx, sy, sz};
		if (kSlice > size[aDir.ordinal()]-1) {
			return res;
		}
		switch (aDir) {
		case X:
			res = new int[sy][sz];
			for (int x = 0; x<sy; x++) {
				for (int y = 0; y<sz; y++) {
					res[x][y] = buffer[kSlice][x][y];
				}
			}
			break;
		case Y:
			res = new int[sx][sz];
			for (int x = 0; x<sx; x++) {
				for (int y = 0; y<sz; y++) {
					res[x][y] = buffer[x][kSlice][y];
				}
			}
			break;
		case Z:
			res = new int[sx][sy];
			for (int x = 0; x<sx; x++) {
				for (int y = 0; y<sy; y++) {
					res[x][y] = buffer[x][y][kSlice];
				}
			}
			break;
		}
		return res;
	}
	
	protected BufferedImage makeImage() {
		int [][] stackSlice = makeSlice(stack, axis, slice);
		int [][] overlaySlice = makeSlice(overlay, axis, slice);
		int sx = stackSlice.length;
		int sy = stackSlice[0].length;
		if ((overlaySlice != null) && ((overlaySlice.length != stackSlice.length) || (overlaySlice[0].length != stackSlice[0].length))) {
			overlaySlice = null;
		}
		try {
			BufferedImage res = new BufferedImage(sx, sy,
					BufferedImage.TYPE_INT_RGB);
			WritableRaster raster = res.getRaster();
			int[] iArray = new int[3];
			for (int x = 0; x < sx; x++) {
				for (int y = 0; y < sy; y++) {
					int pixValue = (int) (255 * ((float)Math.min(maxIntensity, stackSlice[x][y]) / maxIntensity));
					iArray[0] = pixValue;
					iArray[1] = pixValue;
					iArray[2] = pixValue;
					if ((overlaySlice != null) && (overlaySlice[x][y] != 0)) {
						iArray[0] = Math.min(255, (int)(overlayColorFactor[overlaySlice[x][y]][0] * iArray[0]));
						iArray[1] = Math.min(255, (int)(overlayColorFactor[overlaySlice[x][y]][1] * iArray[1]));
						iArray[2] = Math.min(255, (int)(overlayColorFactor[overlaySlice[x][y]][2] * iArray[2]));
					}
					raster.setPixel(x, y, iArray);
				}
			}

			return res;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		
	}
	public void paint(Graphics g) {
		super.paint(g);
		BufferedImage bi = makeImage();
		if (bi != null) {
			Graphics2D g2 = (Graphics2D)g;
			g2.translate(0, getHeight());
			g2.scale(1, -1); // invert Y axis
			g2.drawImage(bi, 0, 0, getWidth(), getHeight(), this);			
			g2.finalize();
		}
	}
	
}

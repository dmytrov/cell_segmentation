package de.unituebingen.cin.celllab.matlab.components;

import java.awt.AWTEvent;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;

import javax.swing.JComponent;

public class JStackViewer extends JComponent {
	private static final long serialVersionUID = 1L;
	protected int[][][] stack = new int[64][64][4];
	protected int[][][] overlay = new int[64][64][4];
	protected int[][] overlaySlice = new int[64][64];
	protected int[] regionType = new int[1];
	public float[][] regionTypeColorFactor = new float[3][4]; 
	public enum Axis {
		X,
		Y,
		Z
	}
	public enum Mode {
		Idle,
		Edit,
		Add,
		Delete
	}
	protected Axis axis = Axis.Z;
	public Mode mode = Mode.Edit;
	public int markerSize = 3;
	public int newRegionType = RegionType.CELL; 
	protected int slice = 0;
	protected int maxIntensity = 32;
	protected int currentMarker = -1;
	protected int sx = 0;
	protected int sy = 0;
	
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
	
	public int[] getRegionType() {
		int[] res = new int [regionType.length];
		System.arraycopy(regionType, 0, res, 0, regionType.length);
		return res;
	}
	
	public void setRegionType(int[] regionType) {
		this.regionType = new int [regionType.length];
		System.arraycopy(regionType, 0, this.regionType, 0, regionType.length);
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
	
	protected void pushSliceToBuffer(int[][][] buffer, Axis aDir, int kSlice, int[][] slice) {
		int sx = buffer.length;
		int sy = buffer[0].length;
		int sz = buffer[0][0].length;
		int[] size = new int[] {sx, sy, sz};
		if (kSlice > size[aDir.ordinal()]-1) {
			return;
		}
		switch (aDir) {
		case X:
			for (int x = 0; x<sy; x++) {
				for (int y = 0; y<sz; y++) {
					buffer[kSlice][x][y] = slice[x][y];
				}
			}
			break;
		case Y:
			for (int x = 0; x<sx; x++) {
				for (int y = 0; y<sz; y++) {
					buffer[x][kSlice][y] = slice[x][y];
				}
			}
			break;
		case Z:
			for (int x = 0; x<sx; x++) {
				for (int y = 0; y<sy; y++) {
					buffer[x][y][kSlice] = slice[x][y];
				}
			}
			break;
		}
	}
	
	protected BufferedImage makeImage() {
		int [][] stackSlice = makeSlice(stack, axis, slice);
		overlaySlice = makeSlice(overlay, axis, slice);
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
					if (overlaySlice[x][y] >= regionType.length)
					{
						overlaySlice = null;
						return null;
					}
					if ((overlaySlice != null) && (overlaySlice[x][y] != 0)) {
						for (int k = 0; k<3; k++) {
							iArray[k] = Math.min(255, (int)(regionTypeColorFactor[regionType[overlaySlice[x][y]]][k] * iArray[k]));
						}
					}
					if (currentMarker == overlaySlice[x][y]) {
						for (int k = 0; k<3; k++) {
							iArray[k] = Math.min(255, iArray[k] * 2);
						}
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
			sx = bi.getWidth();
			sy = bi.getHeight();
			
			Graphics2D g2 = (Graphics2D)g;
			g2.translate(0, getHeight());
			g2.scale(1, -1); // invert Y axis
			g2.drawImage(bi, 0, 0, getWidth(), getHeight(), this);			
			g2.finalize();
		}
	}
	
	protected int getSelectedX(MouseEvent e) {
		return (int)(sx * e.getX() / getWidth());
	}
	
	protected int getSelectedY(MouseEvent e) {
		return (int)(sy - sy * e.getY() / getHeight() - 1);
	}
	
	protected int getOverlaySliceValue(int x, int y) {
		if ((x >= 0) && (x < overlaySlice.length) && (y >= 0) && (y < overlaySlice[0].length)) {
			return overlaySlice[x][y];
		} else {
			return -1;
		}
	}
	
	protected void setOverlaySliceValue(int x, int y, int value) {
		for (int kx = x-markerSize; kx <= x+markerSize; kx++) {
			for (int ky = y-markerSize; ky <= y+markerSize; ky++) {
				if ((kx >= 0) && (kx < overlaySlice.length) && (ky >= 0) && (ky < overlaySlice[0].length) && 
						( Math.sqrt((kx-x)*(kx-x) + (ky-y)*(ky-y)) <= markerSize-0.5)) {
					overlaySlice[kx][ky] = value;
				}
			}
		}
	}
	
	protected int getSelectedID(MouseEvent e) {
		int x = getSelectedX(e); 
		int y = getSelectedY(e);
		return getOverlaySliceValue(x, y);
	}
	
	protected int getFreeID() {
		return regionType.length;
	}
	
	@Override
	protected void processMouseEvent(MouseEvent e) {
		switch (mode) {
			case Idle:
				break;
			case Edit:
				if (e.getID() == MouseEvent.MOUSE_PRESSED) {
					currentMarker = getSelectedID(e);
				} else if (e.getID() == MouseEvent.MOUSE_RELEASED) {
					currentMarker = -1;
				}
				repaint();
				break;
			case Add:
				if (e.getID() == MouseEvent.MOUSE_PRESSED) {
					currentMarker = getFreeID();
					int[] regionTypeNew = new int[regionType.length+1]; 
					System.arraycopy(regionType, 0, regionTypeNew, 0, regionType.length);
					regionTypeNew[regionTypeNew.length-1] = newRegionType;
					regionType = regionTypeNew;
					setOverlaySliceValue(getSelectedX(e), getSelectedY(e), currentMarker);
					pushSliceToBuffer(overlay, axis, slice, overlaySlice);
					mode = Mode.Edit;
					repaint();
				}	
				break;
			case Delete:
				if (e.getID() == MouseEvent.MOUSE_PRESSED) {
					int id = getSelectedID(e);
					if (id > 0) {
						//deleteID(id);
						repaint();
					}
				}
				break;
		}		
	}
	
	@Override
	protected void processMouseMotionEvent(MouseEvent e) {
		switch (mode) {
			case Edit:
				if (e.getID() == MouseEvent.MOUSE_DRAGGED) {
					if (currentMarker >= 0) {
						setOverlaySliceValue(getSelectedX(e), getSelectedY(e), currentMarker);
						pushSliceToBuffer(overlay, axis, slice, overlaySlice);
						repaint();
					}
				}
			default:
		}
	}
	
}

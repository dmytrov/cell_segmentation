package de.unituebingen.cin.celllab.matlab.components;

import java.awt.AWTEvent;
import java.awt.Graphics;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;

import javax.swing.JComponent;

public class JROIEditor extends JComponent {
	public enum Mode {
		Edit,
		Add,
		Delete
	}
	private static final long serialVersionUID = 1L;
	public int scaleX = 5;
	public int scaleY = 5;
	public int[][] img = new int[64][64];
	public int[][] map = new int[64][64];
	public Mode mode = Mode.Edit; 
	protected int currentMarker = -1;
	protected boolean ROIVisible = true;
	
	public JROIEditor() {
		this.enableEvents(AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK);
	}
	
	protected int[][] matrixCopy(int[][] src) {
		if (src == null) {
			return new int[1][1];
		}
		int[][] res = new int[src.length][src[0].length];
		for (int k = 0; k<src.length; k++) {
			System.arraycopy(src[k], 0, res[k], 0, src[k].length);
		}
		return res;
	}
	
	public boolean getROIVisible() {
		return ROIVisible;
	}
	
	public void setROIVisible(boolean value) {
		ROIVisible = value;
		repaint();
	}
	
	public int[][] getImg() {
		return matrixCopy(img);
	}
	
	public synchronized void setImg(int[][] m) {
		img = matrixCopy(m);
		repaint();
	}
	
	public int[][] getMap() {
		return matrixCopy(map);
	}
	
	public synchronized void setMap(int[][] m) {
		map = matrixCopy(m);
		repaint();
	}
	
	public void clearMap() {
		int sx = map.length;
		int sy = map[0].length;
		for (int x = 0; x < sx; x++) {
			for (int y = 0; y < sy; y++) {
				map[x][y] = 0; 
			}
		}
		repaint();
	}
	
	protected synchronized BufferedImage makeImage() {
		if ((img.length != map.length) || (img[0].length != map[0].length)) {
			return null;
		}
		getHeight();
		int sx = img.length;
		int sy = img[0].length;
		scaleX = getWidth() / sx;
		scaleY = getHeight() / sy;
		BufferedImage res = new BufferedImage(scaleX*sx, scaleY*sy, BufferedImage.TYPE_INT_RGB);
		WritableRaster raster = res.getRaster();
		// Draw image
		int[] iArray = new int[3];
		for (int x = 0; x < sx; x++) {
			for (int y = 0; y < sy; y++) {
				int pixValue = img[x][y];
				iArray[0] = pixValue;
				iArray[1] = pixValue;
				iArray[2] = pixValue;
				for (int k1 = 0; k1 < scaleX; k1++) {
					for (int k2 = 0; k2 < scaleY; k2++) {
						raster.setPixel(scaleX*x + k1, scaleY*y + k2, iArray);
					}
				}
			}
		}
		if (!ROIVisible) {
			return res;
		}
		// Draw ROI overlay
		int[] iArrayEdge = new int[] {0, 255, 0};
		int[] iArraySelected = new int[] {255, 0, 0};
		for (int x = 0; x < sx; x++) {
			for (int y = 0; y < sy; y++) {
				if ((x < sx-1) && (map[x][y] != map[x+1][y])) {
					iArray = ((map[x][y] == currentMarker) || (map[x+1][y] == currentMarker) ? iArraySelected : iArrayEdge);
					for (int k = 0; k < scaleY; k++) {
						raster.setPixel(scaleX*(x+1), scaleY*y+k, iArray);
					}
				}
				if ((y < sy-1) && (map[x][y] != map[x][y+1])) {
					iArray = ((map[x][y] == currentMarker) || (map[x][y+1] == currentMarker) ? iArraySelected : iArrayEdge);
					for (int k = 0; k < scaleX; k++) {
						raster.setPixel(scaleX*(x)+k, scaleY*(y+1), iArray);
					}
				}
			}
		}
		return res;
	}
	public void paint(Graphics g) {
		super.paint(g);
		
		BufferedImage bi = makeImage();
		if (bi != null) {
			g.drawImage(bi, 0, 0, this);
		}		
	}
	
	protected int getSelectedX(MouseEvent e) {
		return (int)e.getX() / scaleX;
	}
	
	protected int getSelectedY(MouseEvent e) {
		return (int)e.getY() / scaleY;
	}
	
	protected int getSelectedID(MouseEvent e) {
		int x = getSelectedX(e);
		int y = getSelectedY(e);
		return getMapValue(x, y);
	}
	
	protected int getFreeID() {
		int maxID = -1;
		int sx = map.length;
		int sy = map[0].length;
		for (int x = 0; x < sx; x++) {
			for (int y = 0; y < sy; y++) {
				if (map[x][y] > maxID) {
					maxID = map[x][y]; 
				}
			}
		}
		return maxID + 1;
	}
	
	protected void deleteID(int id) {
		int sx = map.length;
		int sy = map[0].length;
		for (int x = 0; x < sx; x++) {
			for (int y = 0; y < sy; y++) {
				if (map[x][y] == id) {
					map[x][y] = 0; 
				} else if (map[x][y] > id) {
					map[x][y]--;
				}
			}
		}
	}
	
	protected void setMapValue(int x, int y, int value) {
		if ((x >=0) && (x < map.length) && (y >=0) && (y < map[0].length)) {
			map[x][y] = value;
		}
	}
	
	protected int getMapValue(int x, int y) {
		if ((x >=0) && (x < map.length) && (y >=0) && (y < map[0].length)) {
			return map[x][y];
		} else {
			return -1;
		}
	}
	
	@Override
	protected void processMouseEvent(MouseEvent e) {
		switch (mode) {
			case Edit:
				if (e.getID() == MouseEvent.MOUSE_PRESSED) {
					currentMarker = getSelectedID(e);
					repaint();
				} else if (e.getID() == MouseEvent.MOUSE_RELEASED) {
					currentMarker = -1;
					repaint();
				}
				break;
			case Add:
				if (e.getID() == MouseEvent.MOUSE_PRESSED) {
					currentMarker = getFreeID();
					setMapValue(getSelectedX(e), getSelectedY(e), currentMarker);
					mode = Mode.Edit;
					repaint();
				}	
				break;
			case Delete:
				if (e.getID() == MouseEvent.MOUSE_PRESSED) {
					int id = getSelectedID(e);
					if (id > 0) {
						deleteID(id);
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
						setMapValue(getSelectedX(e), getSelectedY(e), currentMarker);
						repaint();
					}
				}
			default:
		}
	}
	
}

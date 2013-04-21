package de.unituebingen.cin.celllab.matlab.components;

import javax.swing.ButtonGroup;
import javax.swing.JPanel;
import javax.swing.JSplitPane;
import java.awt.BorderLayout;
import javax.swing.JRadioButton;
import net.miginfocom.swing.MigLayout;
import javax.swing.JSlider;
import javax.swing.JLabel;
import javax.swing.event.ChangeListener;
import javax.swing.event.ChangeEvent;

import de.unituebingen.cin.celllab.matlab.components.JStackViewer.Axis;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

@SuppressWarnings("serial")
public class JStackViewerPanel extends JPanel {
	public JSplitPane splitPane;
	public JStackViewer stackViewer;
	public JPanel panel;
	public JRadioButton rdbtnX;
	public JRadioButton rdbtnY;
	public JRadioButton rdbtnZ;
	public JSlider slider;
	public JLabel lblSliceNumber;
	public int[] stackSize = new int[] {0, 0, 0};
	public int[] slicePosition = new int[] {0, 0, 0};

	public JStackViewerPanel() {
		setLayout(new BorderLayout(0, 0));
		
		splitPane = new JSplitPane();
		splitPane.setOrientation(JSplitPane.VERTICAL_SPLIT);
		add(splitPane);
		
		stackViewer = new JStackViewer();
		splitPane.setRightComponent(stackViewer);
		
		panel = new JPanel();
		splitPane.setLeftComponent(panel);
		panel.setLayout(new MigLayout("", "[][][][grow][]", "[]"));
		
		rdbtnX = new JRadioButton("X");
		rdbtnX.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				onAxisChanged(Axis.X);
			}
		});
		panel.add(rdbtnX, "cell 0 0");
		
		rdbtnY = new JRadioButton("Y");
		rdbtnY.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				onAxisChanged(Axis.Y);
			}
		});
		panel.add(rdbtnY, "cell 1 0");
		
		rdbtnZ = new JRadioButton("Z");
		rdbtnZ.setSelected(true);
		rdbtnZ.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				onAxisChanged(Axis.Z);
			}
		});
		panel.add(rdbtnZ, "cell 2 0");
		
		slider = new JSlider();
		slider.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent e) {
				int newSlice = slider.getValue();
				slicePosition[stackViewer.getAxis().ordinal()] = newSlice; 
				stackViewer.setSlice(newSlice);
				lblSliceNumber.setText(Integer.toString(newSlice+1) + "/" + Integer.toString(stackSize[stackViewer.getAxis().ordinal()]));
			}
		});
		panel.add(slider, "flowx,cell 3 0,growx");
		
		lblSliceNumber = new JLabel("Slice number");
		panel.add(lblSliceNumber, "cell 4 0");
		splitPane.setDividerLocation(40);
		
		ButtonGroup group = new ButtonGroup();
		group.add(rdbtnX);
		group.add(rdbtnY);
		group.add(rdbtnZ);

		this.revalidate();		
	}
	
	public void onAxisChanged(Axis newAxis) {
		slicePosition[stackViewer.getAxis().ordinal()] = slider.getValue(); 
		stackViewer.setAxis(newAxis);		
		slider.setMaximum(stackSize[stackViewer.getAxis().ordinal()]-1);
		slider.setValue(slicePosition[stackViewer.getAxis().ordinal()]);
	}
	
	public int[][][] getStack () {
		return stackViewer.getStack();
	}
	
	public void setStack(int[][][] stack) {
		stackSize[0] = stack.length;
		stackSize[1] = stack[0].length;
		stackSize[2] = stack[0][0].length;
		for (int k = 0; k < 3; k++) {
			slicePosition[k] = Math.min(slicePosition[k], stackSize[k]);
		}
		stackViewer.setStack(stack);
		stackViewer.setSlice(slicePosition[stackViewer.getAxis().ordinal()]);
		slider.setMinimum(0);
		slider.setMaximum(stackSize[stackViewer.getAxis().ordinal()]-1);
	}
	
	public int[][][] getOverlay() {
		return stackViewer.getOverlay();
	}
	
	public void setOverlay(int[][][] overlay) {
		stackViewer.setOverlay(overlay);
	}
	
	public float[][] getOverlayColorFactor() {
		return stackViewer.getOverlayColorFactor();
	}
	
	public void setOverlayColorFactor(float[][] m) {
		stackViewer.setOverlayColorFactor(m);
	}

}

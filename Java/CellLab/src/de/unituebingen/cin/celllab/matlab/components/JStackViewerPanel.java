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
import de.unituebingen.cin.celllab.matlab.components.JStackViewer.Mode;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JButton;

@SuppressWarnings("serial")
public class JStackViewerPanel extends JPanel {
	public JSplitPane splitPane;
	public JStackViewer stackViewer;
	public JPanel panel;
	public JRadioButton rdbtnX;
	public JRadioButton rdbtnY;
	public JRadioButton rdbtnZ;
	public JSlider sliderSlice;
	public JLabel lblSliceNumber;
	public int[] stackSize = new int[] {0, 0, 0};
	public int[] slicePosition = new int[] {0, 0, 0};
	public JSlider sliderMaxIntensity;
	public JLabel lblMaxIntensity;
	public JLabel lblMaxIntensityIndication;
	public JLabel lblMarkerSizeIndication;
	public JButton btnEdit;
	public JButton btnAddCell;
	public JButton btnAddNoise;
	public JSlider sliderMarkerSize;
	public JLabel lblMarkerSize;
	public JButton btnApply;
	public JButton btnCancel;

	public JStackViewerPanel() {
		setLayout(new BorderLayout(0, 0));
		
		splitPane = new JSplitPane();
		splitPane.setOrientation(JSplitPane.VERTICAL_SPLIT);
		add(splitPane);
		
		stackViewer = new JStackViewer();
		splitPane.setRightComponent(stackViewer);
		
		panel = new JPanel();
		splitPane.setLeftComponent(panel);
		panel.setLayout(new MigLayout("", "[][][][grow][40:40:50]", "[][][][]"));
		
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
		
		sliderSlice = new JSlider();
		sliderSlice.setSnapToTicks(true);
		sliderSlice.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent e) {
				int newSlice = sliderSlice.getValue();
				slicePosition[stackViewer.getAxis().ordinal()] = newSlice; 
				stackViewer.setSlice(newSlice);
				lblSliceNumber.setText(Integer.toString(newSlice+1) + "/" + Integer.toString(stackSize[stackViewer.getAxis().ordinal()]));
			}
		});
		panel.add(sliderSlice, "flowx,cell 3 0,growx");
		
		lblSliceNumber = new JLabel("0/0");
		panel.add(lblSliceNumber, "cell 4 0,alignx right");
		splitPane.setDividerLocation(125);
		
		ButtonGroup group = new ButtonGroup();
		group.add(rdbtnX);
		group.add(rdbtnY);
		group.add(rdbtnZ);
		
		lblMaxIntensity = new JLabel("Max intensity:");
		panel.add(lblMaxIntensity, "cell 0 1 3 1,alignx right");
		
		sliderMaxIntensity = new JSlider();
		sliderMaxIntensity.setValue(32);
		sliderMaxIntensity.setMinimum(1);
		sliderMaxIntensity.setMaximum(255);
		panel.add(sliderMaxIntensity, "cell 3 1,growx");
		
		lblMaxIntensityIndication = new JLabel("0/0");
		panel.add(lblMaxIntensityIndication, "cell 4 1,alignx right");		
		
		lblMarkerSize = new JLabel("Marker size:");
		panel.add(lblMarkerSize, "cell 0 2 3 1,align right");
		
		sliderMarkerSize = new JSlider();
		sliderMarkerSize.setValue(1);
		sliderMarkerSize.setSnapToTicks(true);
		sliderMarkerSize.setMinimum(1);
		panel.add(sliderMarkerSize, "cell 3 2,growx");		
		
		lblMarkerSizeIndication = new JLabel("0/0");
		panel.add(lblMarkerSizeIndication, "cell 4 2,alignx right");
		sliderMarkerSize.setMaximum(20);
		
		btnEdit = new JButton("Edit");
		btnEdit.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				stackViewer.mode = Mode.Edit; 
			}
		});
		panel.add(btnEdit, "cell 0 3,flowx,span,split 5");
		
		btnAddCell = new JButton("Add cell");
		btnAddCell.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				stackViewer.mode = Mode.Add; 
				stackViewer.newRegionType = RegionType.CELL;
			}
		});
		panel.add(btnAddCell);
		
		btnAddNoise = new JButton("Add noise");
		btnAddNoise.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				stackViewer.mode = Mode.Add; 
				stackViewer.newRegionType = RegionType.NOISE;
			}
		});
		panel.add(btnAddNoise);
		
		btnApply = new JButton("Apply");
		panel.add(btnApply);
		
		btnCancel = new JButton("Cancel");
		panel.add(btnCancel);
		
		sliderMaxIntensity.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent e) {
				int newMaxIntensity = sliderMaxIntensity.getValue();
				stackViewer.setMaxIntensity(newMaxIntensity);				
				lblMaxIntensityIndication.setText(Integer.toString(newMaxIntensity) + "/" + Integer.toString(sliderMaxIntensity.getMaximum()));
			}
		});

		sliderMarkerSize.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent e) {
				int newMarkerSize = sliderMarkerSize.getValue();
				lblMarkerSizeIndication.setText(Integer.toString(newMarkerSize) + "/" + Integer.toString(sliderMarkerSize.getMaximum()));
				stackViewer.markerSize = newMarkerSize;
			}
		});
		
		this.revalidate();		
		sliderMarkerSize.setValue(5);
	}
	
	public void onAxisChanged(Axis newAxis) {
		slicePosition[stackViewer.getAxis().ordinal()] = sliderSlice.getValue(); 
		stackViewer.setAxis(newAxis);		
		sliderSlice.setMaximum(stackSize[stackViewer.getAxis().ordinal()]-1);
		sliderSlice.setValue(slicePosition[stackViewer.getAxis().ordinal()]);
	}
	
	public int[][][] getStack () {
		return stackViewer.getStack();
	}
	
	protected void setStack(final int[][][] stack) {
		stackSize[0] = stack.length;
		stackSize[1] = stack[0].length;
		stackSize[2] = stack[0][0].length;
		for (int k = 0; k < 3; k++) {
			slicePosition[k] = Math.min(slicePosition[k], stackSize[k]);
		}
		
		int stackMin = Integer.MAX_VALUE;
		for (int k1 = 0; k1 < stackSize[0]; k1++) {
			for (int k2 = 0; k2 < stackSize[1]; k2++) {
				for (int k3 = 0; k3 < stackSize[2]; k3++) {
					stackMin = Math.min(stackMin, stack[k1][k2][k3]);
				}
			}
		}
		
		int stackMax = 1;
		for (int k1 = 0; k1 < stackSize[0]; k1++) {
			for (int k2 = 0; k2 < stackSize[1]; k2++) {
				for (int k3 = 0; k3 < stackSize[2]; k3++) {
					stack[k1][k2][k3] -= stackMin;
					stackMax = Math.max(stackMax, stack[k1][k2][k3]);
				}
			}
		}
		
		stackViewer.setStack(stack);
		stackViewer.setSlice(slicePosition[stackViewer.getAxis().ordinal()]);
		sliderSlice.setMinimum(0);
		sliderSlice.setMaximum(stackSize[stackViewer.getAxis().ordinal()]-1);
		sliderMaxIntensity.setMaximum(stackMax);
		//sliderMaxIntensity.setValue(stackMax);
	}
	
	public int[][][] getOverlay() {
		return stackViewer.getOverlay();
	}
	
	public void setOverlay(int[][][] overlay) {
		stackViewer.setOverlay(overlay);
	}
	
}

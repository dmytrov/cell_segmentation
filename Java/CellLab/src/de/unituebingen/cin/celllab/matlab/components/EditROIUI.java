package de.unituebingen.cin.celllab.matlab.components;

import de.unituebingen.cin.celllab.matlab.ComponentParameters;
import de.unituebingen.cin.celllab.matlab.ComponentUI;
import de.unituebingen.cin.celllab.matlab.components.JROIEditor.Mode;

import javax.swing.JSplitPane;
import java.awt.BorderLayout;
import javax.swing.JPanel;
import java.awt.Dimension;
import javax.swing.border.EtchedBorder;
import java.awt.Point;
import java.awt.GridLayout;
import net.miginfocom.swing.MigLayout;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class EditROIUI extends ComponentUI {
	public class EditROIUIParameters extends ComponentParameters {
		public int[][] map;
		public int[][] img;
	}
		
	private static final long serialVersionUID = 1L;
	public JSplitPane splitPane;
	public JPanel panel;
	public JPanel panel_1;
	public JPanel panel_2;
	public JROIEditor editor;
	public JButton btnEdit;
	public JButton btnAdd;
	public JButton btnDelete;
	public JButton btnAuto;
	
	@Override
	public ComponentParameters getParameters() {
		EditROIUIParameters params = new EditROIUIParameters();
		params.map = editor.getMap(); 
		params.img = editor.getImg();
		return params;		
	}
	
	@Override
	public void setParameters(ComponentParameters parameters) {
		EditROIUIParameters params = (EditROIUIParameters)parameters;
		editor.setMap(params.map); 
		editor.setImg(params.img);
	}
	
	public EditROIUI() {
		setLayout(new BorderLayout(0, 0));
		
		splitPane = new JSplitPane();
		add(splitPane);
		
		panel = new JPanel();
		splitPane.setLeftComponent(panel);
		panel.setLayout(new MigLayout("", "[]", "[][][][]"));
		
		btnDelete = new JButton("Delete");
		btnDelete.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				editor.mode = Mode.Delete;
			}
		});
		
		btnAdd = new JButton("Add");
		btnAdd.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				editor.mode = Mode.Add;
			}
		});
		
		btnEdit = new JButton("Edit");
		btnEdit.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				editor.mode = Mode.Edit;
			}
		});
		
		btnAuto = new JButton("Auto");
		btnAuto.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				application.runCurrentComponent();
			}
		});
		panel.add(btnAuto, "cell 0 0,growx");
		panel.add(btnEdit, "cell 0 1,growx");
		panel.add(btnAdd, "cell 0 2,growx");
		panel.add(btnDelete, "cell 0 3,growx");
		
		panel_1 = new JPanel();
		splitPane.setRightComponent(panel_1);
		panel_1.setLayout(new GridLayout(1, 0, 0, 0));
		
		panel_2 = new JPanel();
		panel_2.setBorder(new EtchedBorder(EtchedBorder.LOWERED, null, null));
		panel_2.setLocation(new Point(20, 20));
		panel_2.setMaximumSize(new Dimension(150, 150));
		panel_2.setSize(new Dimension(150, 150));
		panel_1.add(panel_2);
		panel_2.setLayout(new BorderLayout(0, 0));
		
		editor = new JROIEditor();
		editor.setSize(new Dimension(150, 150));
		panel_2.add(editor);
		splitPane.setDividerLocation(100);
		
		
	}
}

package de.unituebingen.cin.celllab;

import javax.swing.JFrame;
import javax.swing.JToolBar;
import java.awt.BorderLayout;
import javax.swing.JButton;
import javax.swing.JMenuBar;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JSplitPane;
import javax.swing.JPanel;
import java.awt.FlowLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class CellLabUI extends JFrame{

	private static final long serialVersionUID = 1L;
	public JMenuBar menuBar;
	public JMenu mnFile;
	JMenuItem mntmExit;
	JToolBar toolBar;
	JButton btnNewButton;
	JSplitPane splitPane;
	JPanel panelPipeline;
	JButton btnNewButton_2;
	JButton btnNewButton_3;
	JButton btnNewButton_1;
	JPanel panelComponent;
	public JMenu mnPipeline;
	public JMenu mnHelp;
	
	public CellLabUI() {
		setBounds(100, 100, 698, 523);
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		
		menuBar = new JMenuBar();
		setJMenuBar(menuBar);
		
		mnFile = new JMenu("File");
		menuBar.add(mnFile);
		
		mntmExit = new JMenuItem("Exit");
		mnFile.add(mntmExit);
		
		mnPipeline = new JMenu("Pipeline");
		menuBar.add(mnPipeline);
		
		mnHelp = new JMenu("Help");
		menuBar.add(mnHelp);
		
		toolBar = new JToolBar();
		getContentPane().add(toolBar, BorderLayout.NORTH);
		
		btnNewButton = new JButton("New pipeline...");
		toolBar.add(btnNewButton);
		
		splitPane = new JSplitPane();
		getContentPane().add(splitPane, BorderLayout.CENTER);
		
		panelPipeline = new JPanel();
		splitPane.setLeftComponent(panelPipeline);
		
		btnNewButton_2 = new JButton("New button1");
		
		btnNewButton_3 = new JButton("New button2");
		panelPipeline.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
		panelPipeline.add(btnNewButton_2);
		panelPipeline.add(btnNewButton_3);
		
		btnNewButton_1 = new JButton("New button3");
		panelPipeline.add(btnNewButton_1);
		
		panelComponent = new JPanel();
		splitPane.setRightComponent(panelComponent);
		splitPane.setDividerLocation(110);
	}

}

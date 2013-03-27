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
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import net.miginfocom.swing.MigLayout;

public class CellLabUI extends JFrame{

	private static final long serialVersionUID = 1L;
	public JMenuBar menuBar;
	public JMenu mnFile;
	JToolBar toolBar;
	JButton btnRunAll;
	JSplitPane splitPane;
	JPanel panelPipeline;
	JButton btnNewButton_2;
	JButton btnNewButton_3;
	JButton btnNewButton_1;
	JPanel panelComponent;
	public JMenu mnPipeline;
	public JMenu mnHelp;
	public JButton btnNextComponent;
	private JMenuItem mntmExit;
	public JButton btnRunCurrent;
	public JMenuItem mntmAbout;
	
	public CellLabUI() {
		setTitle("CellLab");
		setBounds(100, 100, 698, 523);
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		
		menuBar = new JMenuBar();
		setJMenuBar(menuBar);
		
		mnFile = new JMenu("File");
		menuBar.add(mnFile);
		
		mntmExit = new JMenuItem("Exit");
		mntmExit.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				CellLabUI.this.setVisible(false);
			}
		});
		mnFile.add(mntmExit);
		
		mnPipeline = new JMenu("Pipeline");
		menuBar.add(mnPipeline);
		
		mnHelp = new JMenu("Help");
		menuBar.add(mnHelp);
		
		mntmAbout = new JMenuItem("About...");
		mnHelp.add(mntmAbout);
		
		toolBar = new JToolBar();
		getContentPane().add(toolBar, BorderLayout.NORTH);
		
		btnRunAll = new JButton("Run all");
		
		toolBar.add(btnRunAll);
		
		btnRunCurrent = new JButton("Run current");		
		toolBar.add(btnRunCurrent);
		
		btnNextComponent = new JButton("Open next");
		toolBar.add(btnNextComponent);
		
		splitPane = new JSplitPane();
		getContentPane().add(splitPane, BorderLayout.CENTER);
		
		panelPipeline = new JPanel();
		splitPane.setLeftComponent(panelPipeline);
		
		btnNewButton_2 = new JButton("New button1");
		
		btnNewButton_3 = new JButton("New button2");
		panelPipeline.setLayout(new MigLayout("", "[97px]", "[23px][23px][23px]"));
		panelPipeline.add(btnNewButton_2, "cell 0 0,alignx left,aligny top");
		panelPipeline.add(btnNewButton_3, "cell 0 1,alignx left,aligny top");
		
		btnNewButton_1 = new JButton("New button3");
		panelPipeline.add(btnNewButton_1, "cell 0 2,alignx left,aligny top");
		
		panelComponent = new JPanel();
		splitPane.setRightComponent(panelComponent);
		splitPane.setDividerLocation(180);
	}

}

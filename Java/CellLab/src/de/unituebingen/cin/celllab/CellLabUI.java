package de.unituebingen.cin.celllab;

import javax.swing.JFrame;
import javax.swing.JToolBar;
import java.awt.BorderLayout;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JMenuBar;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JSplitPane;
import javax.swing.JPanel;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import net.miginfocom.swing.MigLayout;
import javax.swing.JTextArea;
import java.awt.Dimension;
import javax.swing.JScrollPane;
import javax.swing.JCheckBoxMenuItem;

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
	private JMenuItem mntmExit;
	public JButton btnRunCurrent;
	public JMenuItem mntmAbout;
	public JSplitPane splitPane_1;
	public JPanel panel;
	public JTextArea textAreaLog;
	public JScrollPane scrollPane;
	public JMenu mnView;
	public JCheckBoxMenuItem chckbxmntmShowDataComponents;
	public JMenuItem mntmSavePipelineAs;
	public JMenuItem mntmLoadPipeline;
	
	public CellLabUI() {
		setTitle("CellLab");
		setBounds(100, 100, 1200, 570);
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
		
		mntmSavePipelineAs = new JMenuItem("Save pipeline as...");
		mnFile.add(mntmSavePipelineAs);
		
		mntmLoadPipeline = new JMenuItem("Load pipeline...");
		mnFile.add(mntmLoadPipeline);
		mnFile.add(mntmExit);
		
		mnView = new JMenu("View");
		menuBar.add(mnView);
		
		chckbxmntmShowDataComponents = new JCheckBoxMenuItem("Show Data Components");		
		mnView.add(chckbxmntmShowDataComponents);
		
		mnPipeline = new JMenu("Pipeline");
		menuBar.add(mnPipeline);
		
		mnHelp = new JMenu("Help");
		menuBar.add(mnHelp);
		
		mntmAbout = new JMenuItem("About...");
		mntmAbout.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				AboutUI dialog = new AboutUI();
				dialog.setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
				dialog.setVisible(true);				
			}
		});
		mnHelp.add(mntmAbout);
		
		toolBar = new JToolBar();
		getContentPane().add(toolBar, BorderLayout.NORTH);
		
		btnRunAll = new JButton("Run all");
		
		toolBar.add(btnRunAll);
		
		btnRunCurrent = new JButton("Run current");		
		toolBar.add(btnRunCurrent);
		
		splitPane_1 = new JSplitPane();
		splitPane_1.setResizeWeight(1.0);
		splitPane_1.setOrientation(JSplitPane.VERTICAL_SPLIT);
		getContentPane().add(splitPane_1, BorderLayout.CENTER);
		
		panel = new JPanel();
		splitPane_1.setLeftComponent(panel);
		panel.setLayout(new BorderLayout(0, 0));
		
		splitPane = new JSplitPane();
		panel.add(splitPane, BorderLayout.CENTER);
		
		panelPipeline = new JPanel();
		splitPane.setLeftComponent(panelPipeline);
		
		btnNewButton_2 = new JButton("New button1");
		
		btnNewButton_3 = new JButton("New button2");
		panelPipeline.setLayout(new MigLayout("", "[97px]", "[23px][23px][23px][]"));
		panelPipeline.add(btnNewButton_2, "cell 0 0,alignx left,aligny top");
		panelPipeline.add(btnNewButton_3, "cell 0 1,alignx left,aligny top");
		
		btnNewButton_1 = new JButton("New button3");
		panelPipeline.add(btnNewButton_1, "cell 0 2,alignx left,aligny top");
		
		textAreaLog = new JTextArea();
		textAreaLog.setRows(3);
		textAreaLog.setEditable(false);
		textAreaLog.setSize(new Dimension(0, 50));
		
		panelComponent = new JPanel();
		splitPane.setRightComponent(panelComponent);
		panelComponent.setLayout(new BorderLayout(0, 0));
		splitPane.setDividerLocation(180);
		
		scrollPane = new JScrollPane(textAreaLog);
		scrollPane.setAutoscrolls(true);
		splitPane_1.setRightComponent(scrollPane);
	}

}

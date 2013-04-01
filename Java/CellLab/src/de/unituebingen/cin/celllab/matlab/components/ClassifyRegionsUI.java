package de.unituebingen.cin.celllab.matlab.components;

import de.unituebingen.cin.celllab.matlab.ComponentParameters;
import de.unituebingen.cin.celllab.matlab.ComponentUI;
import java.awt.BorderLayout;
import javax.swing.JToolBar;
import javax.swing.JButton;
import de.unituebingen.cin.celllab.opengl.DoubleBufferGLJPanel;

public class ClassifyRegionsUI extends ComponentUI {
	public ClassifyRegionsUI() {
		setLayout(new BorderLayout(0, 0));
		
		toolBar = new JToolBar();
		add(toolBar, BorderLayout.NORTH);
		
		btnAuto = new JButton("Auto");
		toolBar.add(btnAuto);
		
		doubleBufferGLJPanel = new DoubleBufferGLJPanel();
		add(doubleBufferGLJPanel, BorderLayout.CENTER);
	}
	private static final long serialVersionUID = 1L;
	public JToolBar toolBar;
	public JButton btnAuto;
	public DoubleBufferGLJPanel doubleBufferGLJPanel;

	public class ClassifyRegionsUIParameters extends ComponentParameters {
		public String fileName; 
	}
	
	@Override
	public ComponentParameters getParameters() {
		ClassifyRegionsUIParameters params = new ClassifyRegionsUIParameters();
		return params;		
	}
	
	@Override
	public void setParameters(ComponentParameters parameters) {
		ClassifyRegionsUIParameters params = (ClassifyRegionsUIParameters)parameters;
	}
}

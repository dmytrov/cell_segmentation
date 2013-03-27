package de.unituebingen.cin.celllab.matlab;

import javax.swing.JPanel;

public abstract class ComponentUI extends JPanel{
	public ComponentUI() {
	}
	private static final long serialVersionUID = 1L;
	
	public ComponentParameters getParameters() {
		return new ComponentParameters();
	}
	
	public void setParameters(ComponentParameters parameters) {		
	}	
}

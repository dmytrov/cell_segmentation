package de.unituebingen.cin.celllab.matlab;

import javax.swing.JPanel;

public abstract class ComponentUI extends JPanel{
	public ComponentUI() {
	}
	private static final long serialVersionUID = 1L;

	public abstract String getMatlabComponentClass();
	
	public ComponentSettings getSettings() {
		return new ComponentSettings();
	}
	
	public void setSettings(ComponentSettings settings) {		
	}	
}

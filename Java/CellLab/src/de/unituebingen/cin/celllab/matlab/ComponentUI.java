package de.unituebingen.cin.celllab.matlab;

import javax.swing.JPanel;

import de.unituebingen.cin.celllab.Application;
import de.unituebingen.cin.celllab.matlab.IJavaToMatlabListener.ComponentDescription;

public abstract class ComponentUI extends JPanel{
	public Application application;
	public ComponentDescription desc;
	
	public ComponentUI() {
	}
	private static final long serialVersionUID = 1L;
	
	public ComponentParameters getParameters() {
		return new ComponentParameters();
	}
	
	public void setParameters(ComponentParameters parameters) {
	}	
}

package de.unituebingen.cin.celllab.matlab.components;

import de.unituebingen.cin.celllab.matlab.ComponentParameters;
import de.unituebingen.cin.celllab.matlab.ComponentUI;
import javax.swing.JTextField;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.JLabel;
import javax.swing.JButton;
import javax.swing.LayoutStyle.ComponentPlacement;

public class TIFFReaderUI extends ComponentUI {
	public class TIFFReaderUIParameters extends ComponentParameters {
		public String fileName; 
	}
		
	private static final long serialVersionUID = 1L;
	private JTextField textFileName;
	
	@Override
	public ComponentParameters getParameters() {
		TIFFReaderUIParameters params = new TIFFReaderUIParameters();
		params.fileName = textFileName.getText();
		return params;		
	}
	
	@Override
	public void setParameters(ComponentParameters parameters) {
		TIFFReaderUIParameters params = (TIFFReaderUIParameters)parameters;
		textFileName.setText(params.fileName);
	}
	
	public TIFFReaderUI() {
		
		textFileName = new JTextField();
		textFileName.setColumns(10);
		
		JLabel lblNewLabel = new JLabel("Input file:");
		
		JButton btnBrowse = new JButton("Browse...");
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(lblNewLabel)
					.addGap(18)
					.addComponent(textFileName, GroupLayout.PREFERRED_SIZE, 231, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.UNRELATED)
					.addComponent(btnBrowse)
					.addContainerGap(53, Short.MAX_VALUE))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addGroup(groupLayout.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblNewLabel)
						.addComponent(textFileName, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
						.addComponent(btnBrowse))
					.addContainerGap(266, Short.MAX_VALUE))
		);
		setLayout(groupLayout);
	}
}

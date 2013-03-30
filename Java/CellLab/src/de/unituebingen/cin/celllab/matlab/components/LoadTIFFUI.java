package de.unituebingen.cin.celllab.matlab.components;

import de.unituebingen.cin.celllab.matlab.ComponentParameters;
import de.unituebingen.cin.celllab.matlab.ComponentUI;

import javax.swing.JFileChooser;
import javax.swing.JTextField;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.JLabel;
import javax.swing.JButton;
import javax.swing.LayoutStyle.ComponentPlacement;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.io.File;

public class LoadTIFFUI extends ComponentUI {
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
	
	public LoadTIFFUI() {
		
		textFileName = new JTextField();
		textFileName.setColumns(10);
		
		JLabel lblNewLabel = new JLabel("Input file:");
		
		JButton btnBrowse = new JButton("Browse...");
		btnBrowse.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JFileChooser fileChooser = new JFileChooser();
				File currentFile = new File(textFileName.getText());
				File currentPath = new File(currentFile.getAbsolutePath());
				fileChooser.setCurrentDirectory(currentPath);
				fileChooser.setSelectedFile(currentFile);
				int rVal = fileChooser.showOpenDialog(LoadTIFFUI.this);
				if (rVal == JFileChooser.APPROVE_OPTION) {
					textFileName.setText(fileChooser.getSelectedFile().toString());
			    }
			}
		});
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(lblNewLabel)
					.addGap(18)
					.addComponent(textFileName, GroupLayout.PREFERRED_SIZE, 201, GroupLayout.PREFERRED_SIZE)
					.addGap(18)
					.addComponent(btnBrowse)
					.addContainerGap(33, Short.MAX_VALUE))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addGroup(groupLayout.createParallelGroup(Alignment.BASELINE)
						.addComponent(lblNewLabel)
						.addComponent(textFileName, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
						.addComponent(btnBrowse))
					.addContainerGap(247, Short.MAX_VALUE))
		);
		setLayout(groupLayout);
	}
}

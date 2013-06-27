package de.unituebingen.cin.celllab;

import java.awt.BorderLayout;
import java.awt.FlowLayout;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.JTextPane;
import java.awt.SystemColor;

@SuppressWarnings("serial")
public class AboutUI extends JDialog {

	private final JPanel contentPanel = new JPanel();
	public JTextPane txtpnCelllabHttpwwwcinunituebingendeAg;

	public AboutUI() {
		setBounds(100, 100, 450, 300);
		getContentPane().setLayout(new BorderLayout());
		contentPanel.setBorder(new EmptyBorder(5, 5, 5, 5));
		getContentPane().add(contentPanel, BorderLayout.CENTER);
		
		txtpnCelllabHttpwwwcinunituebingendeAg = new JTextPane();
		txtpnCelllabHttpwwwcinunituebingendeAg.setBackground(SystemColor.control);
		txtpnCelllabHttpwwwcinunituebingendeAg.setEditable(false);
		txtpnCelllabHttpwwwcinunituebingendeAg.setText("CellLab - a tool for 2-photon scans processing.\r\nhttp://www.cin.uni-tuebingen.de/\r\nAG Euler, AG Bethge\r\nMain development: Dmytro Velychko\r\nmailto:dmytro.velychko@student.uni-tuebingen.de\r\n2012-2013\r\n[TODO: Add license info here]\r\n[TODO: Add repository link]");
		GroupLayout gl_contentPanel = new GroupLayout(contentPanel);
		gl_contentPanel.setHorizontalGroup(
			gl_contentPanel.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPanel.createSequentialGroup()
					.addGap(34)
					.addComponent(txtpnCelllabHttpwwwcinunituebingendeAg, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
					.addContainerGap(147, Short.MAX_VALUE))
		);
		gl_contentPanel.setVerticalGroup(
			gl_contentPanel.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_contentPanel.createSequentialGroup()
					.addGap(50)
					.addComponent(txtpnCelllabHttpwwwcinunituebingendeAg, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
					.addContainerGap(62, Short.MAX_VALUE))
		);
		contentPanel.setLayout(gl_contentPanel);
		{
			JPanel buttonPane = new JPanel();
			buttonPane.setLayout(new FlowLayout(FlowLayout.RIGHT));
			getContentPane().add(buttonPane, BorderLayout.SOUTH);
			{
				JButton okButton = new JButton("OK");
				okButton.setVisible(false);
				okButton.setActionCommand("OK");
				buttonPane.add(okButton);
				getRootPane().setDefaultButton(okButton);
			}
			{
				JButton cancelButton = new JButton("Cancel");
				cancelButton.setVisible(false);
				cancelButton.setActionCommand("Cancel");
				buttonPane.add(cancelButton);
			}
		}
	}
}

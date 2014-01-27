			== CellLab ==
CellLab is a tool for basic processing of 2-photon retina scans.
Written by: Dmytro Velychko (mailto:dmytro.velychko@student.uni-tuebingen.de)
Tuebingen, CIN, AG Euler, AG Bethge, 2012-2014
http://www.cin.uni-tuebingen.de/

==================================
How to install and run:
----------------------------------
1. In Matlab go to 
  %CodeRoot%\Matlab
 
2. Start it by typing 
  CellLab
in the matlab's command prompt

3. Open Matlab/+Segment3D/TSettings.m file and familiarize yourself with the settings adjustments.

==================================
Known issues:
----------------------------------
If you get "java heap out of memory" errors while processing large stacks,
change java heap settings for matlab. To change it:
1. Create java.opts file in Matlab's bin folder, e.g.
  C:\Program Files\MATLAB\R2012b\bin\win64\java.opts
for Windows x64, with the follwing content (see .\Java\java.opts e.g.): 

----------java.opts file----------
  -Xms128m
  -Xmx512m
----------------------------------
Here
-Xms key is for setting start java heap size,
-Xmx key is for setting max java heap size 

2. Restart matlab

3. In case of more errors try to increase the heap size (-Xmx1024m e.g.).

==================================
TODO list:
----------------------------------
1. Add a fast space partitioning search structure for 3D geometry.

==================================
Development environment used:
----------------------------------
Matlab 2012b with Java remote debugging enabled
Eclipse IDE for Java Developers
WindowBuilder plugin for Eclipse 

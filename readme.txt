cell_segmentation
A tool for basic processing of 2-photon retina scans.
Written by: Dmytro Velychko (mailto:dmytro.velychko@student.uni-tuebingen.de)
Tuebingen, CIN, AG Euler, AG Bethge, 2012-2013
=================
To make it run:
1. Matlab treats static and dynamic classpathes differently. 
It is necessary to add some path to the static classpath, 
which are listed in the classpath.txt file.
Type 
  edit classpath.txt
in the matlab's command prompt.
Add following pathes to the end of the classpath.txt:
  %CodeRoot%\Java\CellLab\bin\
  %CodeRoot%\Java\CellLab\miglayout15-swing.jar
where %CodeRoot% is cell_segmentation code root.

2. Restart matlab

3. In matlab go to 
  %CodeRoot%\Matlab
 
4. Start it by typing 
  CellLab
in the matlab's command prompt

cell_segmentation
A tool for basic processing of 2-photon retina scans.
Written by: Dmytro Velychko (mailto:dmytro.velychko@student.uni-tuebingen.de)
Tuebingen, CIN, AG Euler, AG Bethge, 2012-2013
http://www.cin.uni-tuebingen.de/
=================
To make it run:
-----------------
1. Matlab treats static and dynamic classpathes differently. 
It is necessary to add some pathes to the static classpath, 
which is listed in the classpath.txt file.
Type 
  edit classpath.txt
in the matlab's command prompt.
Add following pathes to the end of the classpath.txt:
  %CodeRoot%\Java\CellLab\bin\
  %CodeRoot%\Java\CellLab\miglayout15-swing.jar
where %CodeRoot% is cell_segmentation code root.
Save the classpath.txt.

2. Restart matlab

3. In matlab go to 
  %CodeRoot%\Matlab
 
4. Start it by typing 
  CellLab
in the matlab's command prompt

=================
Conwn issues:
-----------------
If you get "java heap out of memory" errors while processing large stacks,
change java heap settings for matlab. To change it:
1. Create java.opts file in matlab's bin folder, e.g.
  C:\Program Files\MATLAB\R2012b\bin\win64\java.opts
for Windows x64, with the follwing content: 
  -Xms128m
  -Xmx512m
Xms key is for setting start java heap size,
Xmx key is for setting max java heap size

2. Restart matlab

3. In case of more errors try to increase the heap size.

=================
TODO list:
-----------------
1. Add a fast space partitioning search structure for 3D geometry.
2. Add editing of regions (paintin) on the stack view panel.
3. Add Save/Load of the pipeline object.

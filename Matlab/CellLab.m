%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Startup script for the CellLab application
%
% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2014
%   mailto:dmytro.velychko@student.uni-tuebingen.de
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

currentFilePath = mfilename('fullpath');
dirDelimiters = find(mfilename('fullpath') == filesep);
currentDir = currentFilePath(1:dirDelimiters(end));
clear currentFilePath;
clear dirDelimiters;

% Setup the java classpath helper
javaaddpath([currentDir, '..\Java\CellLab\export\MatlabClassPathHelper.jar']);

% Add java libraries to the system classpath. WARNING: ORDER IS IMPORTANT!
de.tuebingen.cin.celllab.MatlabClassPathHelper.addFileToClassPath([currentDir, '..\Java\lib\vecmath-1.5.1.jar']);
de.tuebingen.cin.celllab.MatlabClassPathHelper.addFileToClassPath([currentDir, '..\Java\lib\miglayout15-swing.jar']);
de.tuebingen.cin.celllab.MatlabClassPathHelper.addFileToClassPath([currentDir, '..\Java\CellLab\export\celllab.jar']);

de.tuebingen.cin.celllab.MatlabClassPathHelper.addFileToClassPath([currentDir, '..\Java\lib\jogl\gluegen-rt-natives-windows-amd64.jar']);
de.tuebingen.cin.celllab.MatlabClassPathHelper.addFileToClassPath([currentDir, '..\Java\lib\jogl\gluegen-rt.jar']);
de.tuebingen.cin.celllab.MatlabClassPathHelper.addFileToClassPath([currentDir, '..\Java\lib\jogl\jogl-all-natives-windows-amd64.jar']);
de.tuebingen.cin.celllab.MatlabClassPathHelper.addFileToClassPath([currentDir, '..\Java\lib\jogl\jogl-all.jar']);

clear currentDir;

% Create the CellLab application
application = Core.TApplication('Cell lab');

% Register the predefined data processing pipelined
application.AddPipelineBuilder(Pipelines.TTracesFromFunctionalScanPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TTracesFromFunctionalScanCorrPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TCreate3DModelsPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TCreate3DModelsCorticalPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TROIFrom3DModelsPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TROIFrom3DModelsProjectionPipelineBuilder());

% Create the CellLab GUI
javaUI = de.unituebingen.cin.celllab.Application();
% Bind the application to the GUI
bridge = JavaBridge.TJavaConnector(application, javaUI);
% Start the GUI
javaUI.onBindingFinished();
%%          QUICKSTART FOR JAVA OpenGL (JOGL) IN MATLAB
%   Make sure the java compiler you are using is of the same version as
%   matlab's runtime, 1.6 for R2012b (otherwise classes will not load with 
%   no explanation).
%
%   Matlab comes with JOGL v1.1.1, qite an old one, but capable of providing 
%   OpenGL v1.x interface. One should use jogl.jar and gluegen-rt.jar form
%   matlab's java\jarext folder. Additionally, to run your JOGL java 
%   applications from an IDE, gluegen-rt.dll, jogl_awt.dll and jogl.dll must be
%   referenced for loading or put into the root folder of the project (can 
%   be found in matlab's bin folder).
%
%   Looks like matlab alredy incorporates the fix for flicker while
%   invalidating the window area and redrawing it, no need for it, althogh 
%   may be necessary to run applications form an IDE: 
%--------------------------------------------------------------------------
%       System.setProperty("sun.awt.noerasebackground", "true");.
%--------------------------------------------------------------------------
%   GLJPanel does not suffer from this bug.
%
%   Matlab uses Swing as its main UI library. Better stick with Swing too 
%   and use GLJPanel.
%
%   To debug java code running in matlab one has to enable JVM debugging via 
%   placing a java.opts file into the bin\win64 (depends on your OS) folder
%   with the following content:
%--------------------------------------------------------------------------
%       -Xdebug
%       -Xrunjdwp:transport=dt_socket,server=y,address=8888,suspend=n
%--------------------------------------------------------------------------
%   It enables jVM remote debugging as a server listening on port 8888.
%   Configure your project in an IDE (Eclise e.g.) for remote debugging,
%   connect to the matlab's JVM debugger, and run/invoke the target java
%   class/method from matlab.
%   
%   To compile java sources form matlab, use
%--------------------------------------------------------------------------
%       !javac -cp ./my_lib1.jar;./my_lib2.jar my_application.java
%--------------------------------------------------------------------------
%
%   To run a java application form matlab, use
%--------------------------------------------------------------------------
%       !java -cp .;./* my_application
%--------------------------------------------------------------------------
%   Use ';' as a delimiter in Windows and ':' in Linux.
%

%%
fprintf('Matlab Java runtime version: %s\n', version('-java'));
fprintf('Current JDK java compiler version: ');
!javac -version

%% Clear matlab java stuff
clear java;
clc;

%% Add classes to the classpath
javaaddpath('../../Java/OpenGLTest/bin');
javaclasspath

%% Invoke the main method
%javaMethodEDT('main_', 'OneTriangleAWT', '')
%javaMethodEDT('main_', 'OneTriangleSwingGLCanvas', '')
%javaMethodEDT('main_', 'OneTriangleSwingGLJPanel', '')
javaMethodEDT('main', 'OpenGLTestApplication', '')








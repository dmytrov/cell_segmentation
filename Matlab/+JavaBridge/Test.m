clc;
clear java;
cd D:\EulersLab\Code\Matlab;

application = Core.TApplication('Cell lab');
application.AddPipelineBuilder(Pipelines.TTestPipelineBuilder());

javaUI = de.unituebingen.cin.celllab.Application();
bridge = JavaBridge.TJavaConnector(application, javaUI);
javaUI.onBindingFinished();

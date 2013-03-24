clc;
cd D:\EulersLab\Code\Matlab;

application = Core.TApplication('Cell lab');
application.AddPipelineBuilder(Pipelines.TTestPipelineBuilder());

javaUI = de.unituebingen.cin.celllab.ApplicationUI();
bridge = JavaBridge.TJavaConnector(application, javaUI.getMatlabConnector());
javaUI.onBindingFinished();

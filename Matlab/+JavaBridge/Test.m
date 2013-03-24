clc;

application = Core.TApplication('Cell lab');
application.AddPipelineBuilder(Pipelines.TTestPipelineBuilder());

ui = de.unituebingen.cin.celllab.ApplicationUI();
bridge = JavaBridge.TApplicationBridge(application, ui);

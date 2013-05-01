application = Core.TApplication('Cell lab');
%application.AddPipelineBuilder(Pipelines.TTestPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TTracesFromFunctionalScanPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TTracesFromFunctionalScanCorrPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TCreate3DModelsPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TROIFrom3DModelsPipelineBuilder());
application.AddPipelineBuilder(Pipelines.TROIFrom3DModelsProjectionPipelineBuilder());

javaUI = de.unituebingen.cin.celllab.Application();
bridge = JavaBridge.TJavaConnector(application, javaUI);
javaUI.onBindingFinished();
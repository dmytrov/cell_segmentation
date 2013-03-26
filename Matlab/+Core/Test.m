%%
clc;
clear classes;

application = Core.TApplication('Cell lab');
application.AddPipelineBuilder(Pipelines.TTestPipelineBuilder());
application.BuildPipelineByName('TIFF reading test pipeline');
application.Pipeline.RunAll();

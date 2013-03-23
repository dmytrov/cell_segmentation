%function Test()
clc;
clear classes;
pipeline = Core.TPipeline('TIFF reading pipeline');

tiffReader = Processors.TTIFFReader('Functional scan');
tiffReader.FileName = '../Data/Q5 512.tif';
visualiser = Processors.TStackVisualiser('Stack UI');

pipeline.AddProcessorsChain({tiffReader, visualiser});
pipeline.Run(visualiser);


%end
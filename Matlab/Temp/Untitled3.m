kernelVariance = ([10, 10, 1]); 
kernelSize = round(3 * kernelVariance ) * 2 + 1; % odd simentionality
k = ImageUtils.Make3DGaussKernel(kernelSize(1), kernelSize(2), kernelSize(3), ...
        kernelVariance(1), kernelVariance(2), kernelVariance(3));
viewer = UI.StackProfileViewer(k);    
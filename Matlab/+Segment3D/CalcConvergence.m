% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function res = CalcConvergence(settings, scan)
    % Blur
    kernelVariance = settings.ConvergenceBlurVariance;
    kernelSize = round(3 * kernelVariance / 2) * 2 + 1; % odd dimentionality    
    k = ImageUtils.Make3DGaussKernel(kernelSize, kernelVariance);
    scanBlurred = ImageUtils.FastConvolution3D(scan, k);
    [fx, fy, fz] = ImageUtils.Gradient3D(scanBlurred);
    [fx, fy, fz] = ImageUtils.Clamp3D(fx, fy, fz, 0, 0.1);
    
    % Construct convergence kernel
    kernelVariance = settings.MicronToPix(settings.ConvergenceKernelVariance); 
    kernelSize = round(3 * kernelVariance / 2) * 2 + 1; % odd dimentionality
    k = ImageUtils.Make3DGaussKernel(kernelSize, kernelVariance);

    % Fast convergence
    res = ImageUtils.FastConvergence3D(fx, fy, fz, k);
end
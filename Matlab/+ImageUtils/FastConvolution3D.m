function res = FastConvolution3D(stack, kernel)
    stackFFT = fftn(stack);

    kernelSized = zeros(size(stack));
    kernelSized(round((size(kernelSized, 1)-size(kernel, 1))/2+1):round((size(kernelSized, 1) + size(kernel, 1))/2), ...
                round((size(kernelSized, 2)-size(kernel, 2))/2+1):round((size(kernelSized, 2) + size(kernel, 2))/2), ...
                round((size(kernelSized, 3)-size(kernel, 3))/2+1):round((size(kernelSized, 3) + size(kernel, 3))/2)) = kernel;

    kernelSizedFFT = fftn(kernelSized);
    
    stackFFTFiltered = stackFFT .* conj(kernelSizedFFT);
    res = fftshift(ifftn(stackFFTFiltered));
end
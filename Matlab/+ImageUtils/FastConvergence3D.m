function res = FastConvergence3D(fx, fy, fz, kernel)
    sx = size(kernel, 1); midx = (sx+1)/2;
    sy = size(kernel, 2); midy = (sy+1)/2;
    sz = size(kernel, 3); midz = (sz+1)/2;
    % X convergence
    m = ones(size(kernel));
    m(midx, :, :) = 0;
    m(midx+1:sx, :, :) = -1;
    kConvX = kernel .* m;
    convX = ImageUtils.FastConvolution3D(fx, kConvX);
    % Y convergence
    m = ones(size(kernel));
    m(:, midy, :) = 0;
    m(:, midy+1:sy, :) = -1;
    kConvY = kernel .* m;
    convY = ImageUtils.FastConvolution3D(fy, kConvY);
    % Z convergence
    m = ones(size(kernel));
    m(:, :, midz) = 0;
    m(:, :, midz+1:sz) = -1;
    kConvZ = kernel .* m;
    convZ = ImageUtils.FastConvolution3D(fz, kConvZ);
    
    res = convX + convY + convZ;
end
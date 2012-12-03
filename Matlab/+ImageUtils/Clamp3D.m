% Clamp value to range
function [fxc, fyc, fzc] = Clamp3D(fx, fy, fz, low, high)
    fNorm = sqrt(fx.^2 + fy.^2 + fz.^2);    
    %res = x;
    factor = ones(size(fNorm));
    factor(fNorm > high) = (high ./ fNorm(fNorm > high));
    factor(fNorm < low)  = (low  ./ fNorm(fNorm < low));
    fxc = fx .* factor;
    fyc = fy .* factor;
    fzc = fz .* factor;
end
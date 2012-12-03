function res = Convergence(fx, fy, kernel)
    res = zeros(size(fx'));
    [kx, ky] = size(kernel);        
    halfX = (kx-1)/2;
    halfY = (ky-1)/2;
    [sx, sy] = size(fx');
    fxe = zeros(sx+2*halfX, sy+2*halfY);
    fxe(halfX+1:halfX+sx, halfY+1:halfY+sy) = fx';
    fye = zeros(sx+2*halfX, sy+2*halfY);
    fye(halfX+1:halfX+sx, halfY+1:halfY+sy) = fy';
    %[sx, sy] = size(fxe);
    for k1 = 1:sx
        for k2 = 1:sy
            %piece = scan(k1:round(k1+kx-1), k2:round(k2+ky-1));
            conv = 0;
            for k3 = 1:kx
                for k4 = 1:ky
                    vField = kernel(k3,k4) *[fxe(k1+k3-1, k2+k4-1), fye(k1+k3-1, k2+k4-1)];
                    vCenter = [(kx-1)/2 - k3+1, (ky-1)/2 - k4+1];
                    if (norm(vCenter) ~= 0)
                        vCenter = vCenter/norm(vCenter);
                        conv = conv + vField*vCenter';
                    end
                end
            end
            res(k1, k2) = conv;
        end
    end
    res = res';
end
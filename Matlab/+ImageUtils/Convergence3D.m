function res = Convergence3D(fx, fy, fz, kernel)
    res = zeros(size(fx));
    [kx, ky, kz] = size(kernel);        
    halfX = (kx-1)/2;
    halfY = (ky-1)/2;
    halfZ = (kz-1)/2;
    [sx, sy, sz] = size(fx);
    % Extended vector fields
    feSize = [sx+2*halfX, sy+2*halfY, sz+2*halfZ];
    fxe = zeros(feSize);
    fxe(halfX+1:halfX+sx, halfY+1:halfY+sy, halfZ+1:halfZ+sz) = fx;
    fye = zeros(feSize);
    fye(halfX+1:halfX+sx, halfY+1:halfY+sy, halfZ+1:halfZ+sz) = fy;
    fze = zeros(feSize);
    fze(halfX+1:halfX+sx, halfY+1:halfY+sy, halfZ+1:halfZ+sz) = fz;
    %[sx, sy] = size(fxe);
    for k1 = 1:sx
        for k2 = 1:sy
            for k3 = 1:sz
                %piece = scan(k1:round(k1+kx-1), k2:round(k2+ky-1));
                conv = 0;
                for j1 = 1:kx
                    for j2 = 1:ky
                        for j3 = 1:kz
                            vField = kernel(j1, j2, j3) * [fxe(k1+j1-1, k2+j2-1, k3+j3-1), ...
                                                           fye(k1+j1-1, k2+j2-1, k3+j3-1), ...
                                                           fze(k1+j1-1, k2+j2-1, k3+j3-1)];
                            vCenter = [halfX - j1+1, halfY - j2+1, halfZ - j3+1];
                            if (norm(vCenter) ~= 0)
                                vCenter = vCenter / norm(vCenter);
                                conv = conv + vField * vCenter';
                            end
                        end
                    end
                end
                res(k1, k2, k3) = conv;
            end
        end
    end
end
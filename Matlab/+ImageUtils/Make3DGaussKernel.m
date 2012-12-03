function mdg = Make3DGaussKernel(sizeX, sizeY, sizeZ, covX, covY, covZ)
    mdg = nan(sizeX, sizeY, sizeZ);
    mCovar = eye(3);
    mCovar(1,1) = covX;
    mCovar(2,2) = covY;
    mCovar(3,3) = covZ;
    for k1 = 1:sizeX
        for k2 = 1:sizeY
            for k3 = 1:sizeZ
                mdg(k1, k2, k3) = mvnpdf([k1, k2, k3], ([sizeX, sizeY, sizeZ] + 1)/2, mCovar);
            end
        end
    end
end
function mdg = Make3DGaussKernel(kSize, kCov)
    %mdg = nan(sizeX, sizeY, sizeZ);
    mCovar = eye(3);
    mCovar(1,1) = kCov(1)^2;
    mCovar(2,2) = kCov(2)^2;
    mCovar(3,3) = kCov(3)^2;
    X = nan(kSize(1), kSize(2), kSize(3), 3);
    for k1 = 1:kSize(1)
        for k2 = 1:kSize(2)
            for k3 = 1:kSize(3)
                X(k1, k2, k3, :) = [k1, k2, k3];
            end
        end
    end
    X = reshape(X, [kSize(1) * kSize(2) * kSize(3), 3]);
	mdgVectors = mvnpdf(X, ([kSize(1), kSize(2), kSize(3)] + 1)/2, mCovar);
    mdg = reshape(mdgVectors, [kSize(1), kSize(2), kSize(3)]);
end
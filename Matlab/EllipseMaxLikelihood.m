% Generate simple elliptic distribution
function EllipseMaxLikelihood()
    CovarMatrixEstimation();
    %SimpleEstimation();    
end


function CovarMatrixEstimation()
    nPoints = 1000;     
    x0 = [3; 1];
    scaling = [2, 1];
    rotAngle = 30;
    x1 = GenEllipticRand(nPoints, x0, scaling, rotAngle);
    x2 = GenEllipticRand(nPoints, x0, 3 * scaling, rotAngle);
    x = [x1, x2];
    
    figure(1);
    plot(x(1, :), x(2, :), '.');

    mCov = cov(x');
    [v, d] = eig(mCov);
    center = mean(x, 2);
    ell = 2 * v * sqrt(d);
    
    grid on; hold on;
    plot(center(1), center(2), '.r');
    plot(ell(1, :) + center(1), ell(2, :) + center(2), '.r');
    plot([center(1), ell(1, 1) + center(1)], [center(2), ell(2, 1) + center(2)], 'r');
    plot([center(1), ell(1, 2) + center(1)], [center(2), ell(2, 2) + center(2)], 'r');
    
    axis image;
    hold off;
end

function x = GenEllipticRand(nPoints, x0, scaling, rotAngle)
    mCorr = diag(scaling);
	mCorr = RorMat2D(rotAngle) * mCorr;

    x = 2 * (rand(2, nPoints) - 0.5);
    bInSircle = sum(x.*x, 1) < 1^2;
    x = x(:, bInSircle);
    x = mCorr * x + repmat(x0, 1, size(x, 2));
end

function SimpleEstimation()
    figure(1)
    x0 = [3; 1];
    mCorr = [3, 1; ...
             -1, 1];

    nPoints = 1000;     
    x = rand(2, nPoints) - 0.5;
    bInSircle = sum(x.*x, 1) < 0.5^2;
    x = x(:, bInSircle);
    x = mCorr * x + repmat(x0, 1, size(x, 2));
    x = [x, 10 * rand(2, 100)];
    
    figure(1);
    plot(x(1, :), x(2, :), '.');

    mCov = cov(x');
    [v, d] = eig(mCov);
    center = mean(x, 2);
    ell = 2 * v * sqrt(d);
    
    grid on;
    hold on;
    plot(center(1), center(2), '.r');
    plot(ell(1, :) + center(1), ell(2, :) + center(2), '.r');
    plot([center(1), ell(1, 1) + center(1)], [center(2), ell(2, 1) + center(2)], 'r');
    plot([center(1), ell(1, 2) + center(1)], [center(2), ell(2, 2) + center(2)], 'r');
    
    
    axis image;
    hold off;
end

function R = RorMat2D(x)
    %2D Rotation matrix counter-clockwise.
    %R=R2d(deg)
    %Input is in degrees.
    R= [cosd(x),-sind(x); sind(x),cosd(x)]; 
end

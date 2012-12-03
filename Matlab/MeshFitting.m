%% Load the image
fileName = '..\..\Data\Q5 512.tif';
scan = ImageUtils.LoadTIFF(fileName);

% Fix edges
scan = scan(:, 4:end, :);

%% Crop the scanning region
nMax = 300;
scan = scan(1:nMax, 1:nMax, :);
iResizeFactor = 5;
scan = ImageUtils.ImageStackResize(scan, iResizeFactor);

%% Calulate the convergence 
[fx, fy, fz] = gradient(scan);
fxyz = abs(fx) + abs(fy) + abs(fz);
sx = 7;
sz = 3;
cx = 1.8;
cy = 1.8;
cz = 0.5;
gKernel = ImageUtils.Make3DGaussKernel(sx, sx, sz, cx, cy, cz);
conver = ImageUtils.Convergence3D(fy, fx, fz, gKernel) + 1;

%%
%close all;
for k = 20:30
    kSclice = k;
    figure(k);
    subplot(1,2,1);
    imagesc(squeeze(scan(:,kSclice,:))); axis square;
    subplot(1,2,2);
    imagesc(squeeze(conver(:,kSclice,:))); axis square;
end

%% Make a spherical mesh
model = WEMesh.TModel;
model.MakeTetrahedron();

ptCenter = MeshUtils.GetCenter(model);
fRadius = 1;
for k = 1:4
    model.DivideAllEdges();
    model.TriangulateAllFacets();
    MeshUtils.ProjectOnSphere(model, ptCenter, fRadius);
end
MeshUtils.Translate(model, -ptCenter);

%% Shoot some rays
%close all;
%ptCell = [59, 57, 25]' - 0.5; % huge peak at a corner
ptCell = [20, 38, 25]' - 0.5; % almost round cell
%MeshUtils.Translate(model, ptCell);
pt1 = ptCell;
figure(2);
k = 1;
v = rand(3,1); v = v/norm(v);
for ve = model.lVertices
    %if (abs(ve.pt(3)) < 0.1) || 1
    if (180*acos(ve.pt'*v)/pi < 30)
        pt2 = pt1 + 5*ve.pt;
        [ptIntersectRes, imgCoords, imgValAtPt] = Collision.VectorImageIntersect(pt1, pt2, conver);
        dist = sqrt(sum((ptIntersectRes - repmat(pt1, 1, size(ptIntersectRes, 2))).^2, 1));
        bClose = (dist < 10);
%         xInterp = 0:0.1:10;
%         yInterp = spline(dist(bClose), imgValAtPt(bClose), xInterp);
%         plot(xInterp, yInterp); hold on;
        c = 0.5 + 0.5*ve.pt(3);
        color = hsv2rgb(c, 1, 1);
        plot(dist(bClose), imgValAtPt(bClose), 'color', color); hold on;
    end
%     if (k > 20)
%         break;
%     end
%     k = k + 1;
end

%% Rough cell fit
ptCell = [20, 38, 25]' - 0.5; % almost round cell
pt1 = ptCell;
figure(2);
opengl hardware;
for ve = model.lVertices
    ve.pt = ve.pt/norm(ve.pt);
    pt2 = pt1 + 5*ve.pt;
    [ptIntersectRes, imgCoords, imgValAtPt] = Collision.VectorImageIntersect(pt1, pt2, conver);
    dist = sqrt(sum((ptIntersectRes - repmat(pt1, 1, size(ptIntersectRes, 2))).^2, 1));

    bClose = (dist < 6);
    imgValAtPt = imgValAtPt(bClose);
    dist = dist(bClose);
    [c, i] = min(imgValAtPt);
    ve.pt = ve.pt * dist(i);
end
plot(model);

%% 
figure(1);
z = squeeze(scan(round(ptCell(1)), round(ptCell(2)), :));
plot(z); hold on;
kernel = normpdf(-20:1:20, 0, 2);
plot(40*kernel, 'r');
[d, r] = deconv(z', kernel);
plot(d); 

%%
I = checkerboard(15);
PSF = fspecial('motion', 30, 30);
%PSF = fspecial('gaussian',7,2);
V = .0001;
BlurredNoisy = 100*imfilter(I, PSF);
BlurredNoisy = poissrnd(BlurredNoisy)+0.5;
%BlurredNoisy = imnoise(imfilter(I,PSF),'gaussian',0,V);
WT = zeros(size(I));
WT(5:end-4,5:end-4) = 1;
J1 = deconvlucy(BlurredNoisy,PSF);
J2 = deconvlucy(BlurredNoisy,PSF,20,sqrt(V));
J3 = deconvlucy(BlurredNoisy,PSF,20,sqrt(V),WT);

figure(1);
subplot(221);imagesc(BlurredNoisy); axis square;
title('A = Blurred and Noisy');
subplot(222);imagesc(J1); axis square;
title('deconvlucy(A,PSF)');
subplot(223);imagesc(min(J2, 200)); axis square;
title('deconvlucy(A,PSF,NI,DP)');
subplot(224);imagesc(J3); axis square;
title('deconvlucy(A,PSF,NI,DP,WT)');










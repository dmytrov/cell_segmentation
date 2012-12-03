%%
figure(1); nFigs = 5;
t = 0:0.1:100;
x = 0.5 * (1 + sin(t/8));
subplot(nFigs, 1, 1);
plot(x);
%
y = rand(size(t)) < x/8;
subplot(nFigs, 1, 2);
plot(y);
%
clear ll;
i = 1;
sig = 1:0.5:20;
for sigma = sig
    q = -3*sigma:0.1:3*sigma;
    k = normpdf(q, 1, sigma);
    yInd = find(y);
    yInd = yInd(1:1:length(yInd));
    yDec = zeros(size(y));
    yDec(yInd) = 1;
    xRec = conv(double(yDec), k);
    xRec = xRec(round((length(k)/2)) : (round(length(k)/2) + length(x) - 1));
    xRec = xRec/sum(xRec);
    %log-like
    p = xRec(y);
    p(p==0) = 1;
    loglik(i) = -sum(log(p));
    i = i + 1;
end
subplot(nFigs, 1, 3);
plot(xRec)
subplot(nFigs, 1, 4);
plot(sig, loglik);

%% Annealing of the free energy
xyRange = 200:400;
y = scan(xyRange, xyRange, 10);
figure(1);
subplot(2, 3, 1);
imagesc(y);
x = randi(2, size(y))-1;
subplot(2, 3, 2);
imagesc(x);

nIterations = 10000;
[s1, s2] = size(y);
for k = 1:nIterations
   k1 = randi(s1);
   k2 = randi(s2);
end

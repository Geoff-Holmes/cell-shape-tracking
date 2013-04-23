% migration test

clear all
close all

centroid = 0;
velocity = 5* exp(1i*rand()*2*pi);
% speed limiting factor
Smax = 3;
S0 = randi(Smax);
B0 = 1;
alphaS = 0.5;
alphaB = 0.5;
% boundary frequency
f = 10;
% number of boundary sample points
Nb = 100;
%create a correlation matrix
% s = Nb:-1:1;
s = [f:-1: 1 zeros(1,Nb-2*f+1) 1:f-1];
for i = 1:Nb
    C(i,:) = circshift(s, [1,i-1]);
end
C = C/sum(C(1,:), 2);

radials = ones(Nb, 1);

rng = linspace(0, 2*pi, Nb+1)';

figure; axis equal; hold on

for i = 1:10

    if rand() < 0.25
        S0 = randi(Smax);
    end
    bndry = [radials; radials(1)] .* exp(1i*rng);
    pCell = plot(centroid + bndry);
    centroid = centroid + velocity;
    cen(i) = centroid;
    if i > 1, line(real(cen(i-1:i))', imag(cen(i-1:i))'); end
    velocity = velocity + 5*[1 1i]*randn(2,1);
    S = abs(velocity);
    velocity = velocity / S;
    S = S + alphaS * (S0 - S);
    velocity = velocity * S;
    radials = radials + alphaB * (B0 - radials) +  1 * C * randn(Nb, 1);
    
end
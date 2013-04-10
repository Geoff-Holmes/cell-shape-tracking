close all;
clear all;

r = 2; c = 2;

B = grhBspline(12,4);

subplot(r,c,1);axis([0 1 0 1]); axis equal;hold on;
x = ginput(12);
x = x(:,1) + 1i*x(:,2);

[~, S1] = B.dataFit(x);
plot(S1); 


hold on;

% ST = grhShapeTemplate(S1.ctrlPts, B, 'planarAffine');
ST = grhShapeTemplate(S1.ctrlPts, B, 'euclideanSimilarities');

y = ginput(12);
y = y(:,1) + 1i*y(:,2);
[~, S2] = B.dataFit(y);
subplot(r,c,2); plot(S2); axis([0 1 0 1]);axis equal;

S3.ctrlPts = 1-S3.ctrlPts;
X = ST.project(S3);
S3 = ST.transform(X);
subplot(r,c,3); plot(S3); %axis([0 1 0 1]);axis equal; hold on;

X = ST.project(wrev(S1.ctrlPts));
S3 = ST.transform(X);
subplot(r,c,4); plot(S3); axis([0 1 0 1]);axis equal;
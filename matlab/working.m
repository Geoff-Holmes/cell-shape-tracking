clear all
close all

load fishTemplateCtrlPts
B = grhBspline(12, 4);
Q = grhSnake(x, B);



% [y, X] = B.planarAffineTransform(x, 100*(1+1i), 2, 0);
% X
% 
% plot(B.curve(x),'r')
% hold on
% plot(B.curve(y),'g')
% axis equal



% cd ~/Dropbox/activeContours/matlab/
%   
% data = 'neutroImages_Phil_XYpoint7';
% 
% B = grhBspline();
% % ? constant velocity model
% % M = grhModel(eye(2*B.L), zeros(1,2*B.L), 10*eye(2*B.L), 2);
% % Random walk model
% M = grhModel(eye(B.L), zeros(1,B.L), 10*eye(B.L), 2);
% H = grhImageHandler(0,45);
% 
% Mg = grhManager(B, M, H, data);
% clear B M H data
% 
% Mg = Mg.firstFrame();
% Mg = Mg.iterate();


% % circle
% s = 0:19;
% X = exp(s*2*pi*1i/20);
% 
% % square
% X = [0:4 4+1i*(0:4) 4*1i+(4:-1:0) 1i*(4:-1:0)];
% 
% X = reshape(X, length(X), 1);
% Y = X+1;
% Z = 2*X;
% 
% AX = Mg.Bspline.getArea(X)
% AY = Mg.Bspline.getArea(Y)
% AZ = Mg.Bspline.getArea(Z)
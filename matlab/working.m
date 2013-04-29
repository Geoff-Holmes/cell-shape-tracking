close all
clear all

% initialise spline
B = grhBspline(20, 1);

cd ~/Dropbox/activeContours/matlab/
data = 'neutroImages_Phil_XYpoint7';

% for random walk model
% A = sparse(eye(B.L));
% C = [];
% W = sparse(10*eye(B.L));
% v = 5;

% for constant velocity model
dt = 1;
A = sparse([eye(B.L) dt*eye(B.L); zeros(B.L) eye(B.L)]);
C = []; 
Q = 10*sparse(toeplitz([2 1 zeros(1, B.L-3) 1], [2 1 zeros(1, B.L-3) 1]));
G = sparse([dt^2/2*eye(B.L); dt*eye(B.L)]);
W = G * Q * G';
v = 5;

% construct dynamic model
M = grhModel(A, C, W, v);

% construct image handler 
H = grhImageHandler(0,45);

% contruct process manager
Mg = grhManager(B, M, H, @correspondNN, 75, data);
clear A B C G H M Q W v dt data

% do the main business
Mg = Mg.firstFrame();
Mg = Mg.iterate();
Mg = Mg.smoothAllCellStates();
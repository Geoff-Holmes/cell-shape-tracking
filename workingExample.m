close all
clear all

% initialise spline
B = grhBspline();

data = 'neutroImages_Phil_XYpoint7';

% for random walk model
% A = sparse(eye(B.L));
% C = [];
% W = sparse(10*eye(B.L));
% v = 5;

% for constant velocity model
dt = 1;
% state update matrix
A = sparse([eye(B.L) dt*eye(B.L); zeros(B.L) eye(B.L)]);
% observation matrix empty since time varying and evaluated each time
C = []; 
% some correlation between states
% but what about correlation between velocities and positions
Q = 10*sparse(toeplitz([2 1 zeros(1, B.L-3) 1]));
% see Bar-Shalom Estimation with Appln to Tracking ... (2001) p218
G = sparse([dt^2/2*eye(B.L); dt*eye(B.L)]);
W = G * Q * G';
% observation noise level
v = 5;

% construct dynamic model
M = grhModel(A, C, W, v);

% construct image handler 
H = grhImageHandler(0,45);

% contruct process manager
Mg = grhManager(B, M, H, @correspondNN, 75, data);
clear A B C G H M Q W v dt data

% do the main business
Mg.firstFrame();
Mg.iterate();
Mg.smoothAllCellStates();


% show some results
iCell = 20;
Mg.showTrack(iCell);
Mg.showCellBoundaryVelocites(iCell);
Mg.showAllTracks();
Mg.showInfo();

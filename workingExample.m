function [Mg, longTracks] = workingExample(framesToProcess)

% add path to main code and make sure spline matrices are on search path
addpath('~/Dropbox/CSTdevelopment/')
addpath(genpath('~/Dropbox/CSTdevelopment/functions'))

% initialise spline
B = grhBspline(20,3);

% dataName = 'neutroImages_Phil_XYpoint7';
dataName = 'neutroImages_hiRes';
% dataName = 'testData';

notes = '';

% % for random walk model
% A = sparse(eye(B.L));
% C = [];
% W = sparse(10*eye(B.L));
% v = 5;

% % for random walk model with velocity estimation
% dt = 1;
% A = sparse([eye(B.L) dt*eye(B.L); zeros(B.L) zeros(B.L)]);
% C = [];
% % Q = 10*sparse(eye(B.L));
% % % see Bar-Shalom Estimation with Appln to Tracking ... (2001) p218
% % G = sparse([dt^2/2*eye(B.L); dt*eye(B.L)]);
% % W = G * Q * G';
% W = 100*eye(2*B.L);
% v = 1;
% notes = 'rwmve';

% for constant velocity model
dt = 1;
% state update matrix
A = sparse([eye(B.L) dt*eye(B.L); zeros(B.L) eye(B.L)]);
% observation matrix empty since time varying and evaluated each time
C = []; 
% some correlation between states
% but what about correlation between velocities and positions
% NB ctrl points acheive this anyway if not too many basis functions used.
% Q = 10*sparse(toeplitz([2 1 zeros(1, B.L-3) 1]));
% Q = 1*sparse(eye(B.L));
% % see Bar-Shalom Estimation with Appln to Tracking ... (2001) p218
% G = sparse([dt^2/2*eye(B.L); dt*eye(B.L)]);
% W = G * Q * G';
W = 20*sparse(eye(2*B.L));
% observation noise level
v = 1;
notes = 'cv';

% construct dynamic model
M = grhModel(A, C, W, v);

% construct image handler 
% obj = grhImageHandler(threshB, threshA)
% threshB is minimum boundary length
% threshA is minimum area
H = grhImageHandler(0,45);

% contruct process manager
% grhManager(Bspline, Model, ImageHandler, corresponder, maxMoveThresh, Data)
Mg = grhManager(B, M, H, @correspondAuction, 20, dataName, notes);
clear A B C G H M Q W v dt data

% do the main business
Mg.firstFrame();
if nargin
    Mg.iterate(framesToProcess);
else
    Mg.iterate();
end
Mg.smoothAllCellStates();

longTracks = Mg.showInfo('1')

% show some results
% figure
% axis([0 1040 0 1040])
% for iCell = longTracks
%     Mg.animateTrack(iCell);
% end
% Mg.showCellBoundaryVelocites(iCell);
% Mg.showAllTracks();

flNo = 1;
while exist(['results' num2str(flNo) '.mat'], 'file')
    flNo = flNo + 1;
end
save(['results' num2str(flNo) '.mat'], 'Mg')



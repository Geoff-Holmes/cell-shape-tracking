% function Mg = working(iCell)
% 
% if nargin == 0, iCell = 6; end

clear all

% initialise spline
B = grhBspline();

cd ~/Dropbox/activeContours/matlab/
data = 'neutroImages_Phil_XYpoint7';

% ? constant velocity model
% M = grhModel(eye(2*B.L), zeros(1,2*B.L), 10*eye(2*B.L), 2);

% for random walk model
A = eye(B.L);
C = [];
W = 10*eye(B.L);
v = 20;
% for constant velocity model
dt = 1;
A = [eye(B.L) dt*eye(B.L); zeros(B.L) ones(B.L)];
C = [];
W = 10*eye(2*B.L);
v = 20;

M = grhModel(A, C, W, v);

H = grhImageHandler(0,45);

Mg = grhManager(B, M, H, @correspondNN, data);
clear B M H data

Mg = Mg.firstFrame();
Mg.iterate();

figure; hold on

for i = 1:length(Mg.cells)
    
    thisCell = Mg.cells{i};
    
    for j = 1:thisCell.lastSeen - thisCell.firstSeen
        
        plot(thisCell, j);
        try
        plot(Mg.frames{j+thisCell.firstSeen -1}.bounds{thisCell.obsRefs(j)}, 'r');
        catch ex
            ex
        end
%         pause()
    end
    
end


clear all
close all

% initialise spline
B = grhBspline();

cd ~/Dropbox/activeContours/matlab/
data = 'neutroImages_Phil_XYpoint7';

% ? constant velocity model
% M = grhModel(eye(2*B.L), zeros(1,2*B.L), 10*eye(2*B.L), 2);

% Random walk model
M = grhModel(eye(B.L), zeros(1,B.L), 10*eye(B.L), 2);

H = grhImageHandler(0,45);

Mg = grhManager(B, M, H, data);
clear B M H data

Mg = Mg.firstFrame();

figure; hold on

for i = 6 %1:length(Mg.cells)
    
    CellNo = i
    Mg = Mg.iterate(i);
    
    thisCell = Mg.cells{i}
    
    for j = 1:thisCell.lastSeen - thisCell.firstSeen
        
        plot(thisCell, j)
        %         plot(Mg.frames{j}.bounds{thisCell.obsRefs(j)}, 'r')
        
%         pause()
    end
    
end


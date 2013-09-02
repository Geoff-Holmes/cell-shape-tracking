%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the example for the breast cancer data %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc; close all;
addpath('saveMat/');
addpath('functions/');
load('cellImage');

%% 1. initialize bsplines
Bs = grhBspline(20,4);

%% 2. loading data ---- binary image with same x-y axis
data =  'cellImage';

%% 3. for cv model
A = eye(Bs.L);  A = [A, A;zeros(size(A)) A];
C = [];
B = [ones(Bs.L,1) zeros(Bs.L,1); zeros(Bs.L,1) ones(Bs.L,1)];
P0 = eye(4*Bs.L);
dt = 1;

Q = 10*sparse(toeplitz([2 1 zeros(1, Bs.L-3) 1]));
W = eye(Bs.L*2);
% see Bar-Shalom Estimation with Appln to Tracking ... (2001) p218
% G = sparse([dt^2/2*eye(Bs.L); dt*eye(Bs.L)]);
% W = G * Q * G';
% observation noise level
v = 1;
Model = grhModel(A,C,W,v);

Thd = grhImageHandler();
Mg = grhManager(Bs,Model,Thd,@correspondNN,400,data);
clear A B C G H M Q W v dt data;

Mg.firstFrame();
 
Mg.iterate();

Mg.smoothAllCellStates();

longTracks = Mg.showInfo(1);

save saveMat/MgJ21-F3 Mg longTracks 
 
% --------------------- show some tracking results ------------------
% for iCell = longTracks
%     Mg.animateTrack(iCell);
% end
% 
% Mg.showAllTracks();
% 
% Mg.showCellBoundaryVelocites(2);
%% %%%%%%-----------------lamellipodia ---------------%%%%%%---------------

La = yzhLamellipodia('lameBounds','MgJ21-F3');

%---draw the overview of cell migration/ raw data with lamellipodia---
% La.plotLameAll; 
%---------------------------------------------------------------------

%-------------------correlated cell+lame------------------------------
La.lameAssociateCell(); %La.lameAssociateCell(1)draw the figures
%---------------------------------------------------------------------

%---------find the distribution of lamellipodia for each cell --------
for iCell = longTracks
    iCell
    La.lameLocation(iCell);
end
save saveMat/LaJ21-F3 La
%---------------------------------------------------------------------


%% ----------%%%%%----------- Analysis ------------------%%%%%-------------
% clear all;
% addpath('saveMat/');
% addpath('functions/');
% download('LaJ21-F3');
% download('MgJ21-F3');
Ay = yzhCellAnalysis(Mg,La);
for iCell = longTracks
    PN{iCell} = Ay.cellOrientation(iCell);
end

Ay.orienVsLame(longTracks);

%%%%%


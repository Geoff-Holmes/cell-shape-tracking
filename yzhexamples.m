%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the example for the breast cancer data %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc; close all;
Input = 'Blebb-J19-F2-';
addpath('saveMat/');
addpath('functions/');
load([Input,'cellImage']);

%% 1. initialize bsplines
Bs = grhBspline(20,4);

%% 2. loading data ---- binary image with same x-y axis
data = [Input,'cellImage'];

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

longTracks = Mg.showInfo();
% %------ save  inter -------------------%
 filename = ['saveMat/',Input,'Mg'] ; %%
 save(filename, 'Mg', 'longTracks');  %%
% %--------------------------------------%
 
% --------------------- show some tracking results ------------------
% for iCell = longTracks
%     iCell
%     Mg.animateTracks(iCell);
% %     pause;
% end
% % 
% Mg.showTracks();
% 
% Mg.showCellBoundaryVelocites(2);
%% %%%%%%-----------------lamellipodia ---------------%%%%%%---------------

fileL = [Input,'lamellipodia'];
fileMg = [Input,'Mg'];
La = yzhLamellipodia(fileL,fileMg);

%---draw the overview of cell migration/ raw data with lamellipodia---
% La.plotLameAll; 
%---------------------------------------------------------------------

%-------------------correlated cell+lame------------------------------
La.lameAssociate(); %La.lameAssociateCell(1)draw the figures
%---------------------------------------------------------------------

%---------find the distribution of lamellipodia for each cell --------

% %---------save inter -----------------%
filename = ['saveMat/',Input,'La'];   %
save(filename, 'La');                 %
% %-------------------------------------%




%% ----------%%%%%----------- Analysis ------------------%%%%%-------------

for iCell = longTracks
    iCell
    La.lameLocation(iCell);
end

Ay = yzhCellAnalysis(Mg,La);
for iCell = longTracks
    PN{iCell} = Ay.cellOrientation(iCell);
end
save(['saveMat/',Input,'Ay'],'Ay');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   %
%      anaylsis about the location of lamellipodia     %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
addpath('saveMat/');
addpath('functions/');
load('Blebb-J19-F2-La');
load('Blebb-J19-F2-Mg');
load('Blebb-J19-F2-Ay')
longTracks = Mg.showInfo('1234');
Mg.showTracks();
set(gcf,'color',[1,1,1])
[data2,data21] = Ay.orienVsLame(longTracks,'123');
% save ('figDesign/data2','data2','data21');
%%%


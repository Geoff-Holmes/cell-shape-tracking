function [obj,  enoughBoth, enoughSteps, enoughDist] ...
    = getTrackInfo(obj, angleJumpThresh, minSteps, minDist)

% get stat info on cell tracks
%   Inputs:
%       minSteps and MinDist are thresholds above which a track is
%       considered
%      'good' for further analysis
%       MinDist is compared to total distance covered rather than net
%       distance
%
%   Outputs:
%       indices of tracks which are above the respective thresholds

if nargin < 2
    angleJumpThresh = 5;
end
if nargin < 4
        minSteps = 10;
        minDist  = 30;
end

display(['Angles only calculated where cell moves more than' ...
    num2str(angleJumpThresh) ' units'])

for i = 1 : obj.Ntracks
    
    iCell = obj.cells(i);
    
    % number of timepoints covered by track
    Nsteps               = length(iCell.states);
    info(i).Nsteps       = Nsteps; 
    
    % net movement vector
    netMove              = iCell.centroid(end) - iCell.centroid(1);
    info(i).netMove      = netMove;
    
    % net distance
    info(i).netDistance  = abs(netMove);
    
    % individual cell movements between between each pair of timepoints
    jumps = iCell.centroid(2:end) - iCell.centroid(1:end-1);
    info(i).jumps        = abs(jumps);
    
    % total distance covered
    info(i).totalDistance = sum(abs(jumps));
    
    % trajectory angle change at each time point
    angles = abs(angle(jumps(2:end)- angle(jumps(1:end-1))));
    test1 = angles > pi;
    angles(test1) = 2*pi - angles(test1);
    test2 = abs(jumps(2:end)) < angleJumpThresh;
    angles(test2) = 0;
    info(i).angles       = angles;
    
    % get cell areas
    for j = 1 : Nsteps
        areas(j) = iCell.snake(j).getArea();
    end
    info(i).areas        = areas;
    
end

obj.info = info;

Nsteps = [obj.info(:).Nsteps];
totD   = [obj.info(:).totalDistance];
% test for thresholds
test1 = Nsteps > minSteps;
test2 = totD   > minDist;

if nargout > 1
    iCells = 1:obj.Ntracks;
    enoughBoth  = iCells(test1 & test2);
    enoughSteps = iCells(test1);
    enoughDist  = iCells(test2);
end

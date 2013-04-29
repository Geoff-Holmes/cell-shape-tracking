function info = getTrackInfo(obj)

% get stat info on cell tracks

angleJumpThresh = 5;
display(['Angles only calculated where cell moves more than' ...
    num2str(angleJumpThresh) ' units'])

for i = 1 : obj.Ntracks
    
    iCell = obj.cells{i};
    
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
    
    % trajectory angle change at each time point
    angles = abs(angle(jumps(2:end)- angle(jumps(1:end-1))));
    test1 = angles > pi;
    angles(test1) = 2*pi - angles(test1);
    test2 = abs(jumps(2:end)) < angleJumpThresh;
    angles(test2) = 0;
    info(i).angles       = angles;
    
end


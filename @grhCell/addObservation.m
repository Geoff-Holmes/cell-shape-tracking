function obj = addObservation...
    (obj, ctrlPts, covariance, centroid, obsRefs, centroidShift, states, Cmatrix)

%     Add observation event to cell

% display('adding observation')

obj.lastSeen = obj.lastSeen + 1;
obj.snake(end+1) = grhSnake(ctrlPts, obj.Bspline);
obj.covariance{end+1} = covariance;
obj.centroid(end+1) = centroid;
obj.obsRefs(end+1) = obsRefs;
obj.centroidShift(end+1) = centroidShift;
obj.states{end+1} = states;
obj.Cmatrix{end+1} = Cmatrix;
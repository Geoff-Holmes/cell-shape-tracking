function obj = addObservation...
    (obj, state, covariance, centroid, obsRefs, centroidShift, Cmatrix)

%     Add observation event to cell

% display('adding observation')

obj.lastSeen = obj.lastSeen + 1;
obj.snake(end+1) = grhSnake(state(1:obj.Bspline.L), obj.Bspline);
obj.covariance{end+1} = covariance;
obj.centroid(end+1) = centroid;
obj.obsRefs(end+1) = obsRefs;
obj.centroidShift(end+1) = centroidShift;
obj.states{end+1} = state;
obj.Cmatrix{end+1} = Cmatrix;
function obj = addObservation(obj, ctrlPts, covariance, centroid, obsRefs)

%     Add observation event to cell

% display('adding observation')

obj.lastSeen = obj.lastSeen + 1;
obj.ctrlPts{end+1} = ctrlPts;
obj.covariance{end+1} = covariance;
obj.centroid(end+1) = centroid;
obj.obsRefs(end+1) = obsRefs;
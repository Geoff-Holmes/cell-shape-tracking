function c = getCentroidT(obj, t)

% get centroid of cell at time t via Bspline method

t = t - obj.firstSeen + 1;
try
c = obj.Bspline.getCentroid(obj.snake(t));
catch exGetCentroidT
    exGetCentroidT
end
    


function c = getCentroid(obj, i)

% get centroid of cell via Bspline method

c = obj.Bspline.getCentroid(obj.snake(i));



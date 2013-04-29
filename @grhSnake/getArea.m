function A = getArea(obj)

% pass across to Bspline get area function
A = obj.Bspline.getArea(obj.ctrlPts);


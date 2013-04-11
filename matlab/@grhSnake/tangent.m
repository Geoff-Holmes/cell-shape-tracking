function F = tangent(obj, s)

switch nargin
    case 2
        F = obj.Bspline.eval(obj.ctrlPts, 'tangent', s);
    case 1
        F = obj.Bspline.eval(obj.ctrlPts, 'tangent');
end
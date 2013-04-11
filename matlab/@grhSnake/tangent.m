function F = tangent(obj, s, divs)

switch nargin
    case 3
        F = obj.Bspline.eval(obj.ctrlPts, 'tangent', s, divs);
    case 2
        F = obj.Bspline.eval(obj.ctrlPts, 'tangent', s);
    case 1
        F = obj.Bspline.eval(obj.ctrlPts, 'tangent');
end
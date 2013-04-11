function F = normal(obj, s)

switch nargin
    case 2
        F = obj.Bspline.eval(obj.ctrlPts, 'normal', s);
    case 1
        F = obj.Bspline.eval(obj.ctrlPts, 'normal');
end
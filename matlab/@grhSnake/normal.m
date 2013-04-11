function F = normal(obj, s, divs)

switch nargin
    case 3
        F = obj.Bspline.eval(obj.ctrlPts, 'normal', s, divs);
    case 2
        F = obj.Bspline.eval(obj.ctrlPts, 'normal', s);
    case 1
        F = obj.Bspline.eval(obj.ctrlPts, 'normal');
end
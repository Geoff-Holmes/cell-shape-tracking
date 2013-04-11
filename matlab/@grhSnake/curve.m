function F = curve(obj, s)

switch nargin
    case 2
        F = obj.Bspline.eval(obj.ctrlPts, 'curve', s);
    case 1
        F = obj.Bspline.eval(obj.ctrlPts, 'curve');
end
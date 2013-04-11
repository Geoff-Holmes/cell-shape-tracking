function F = curve(obj, s, divs)

switch nargin
    case 3
        F = obj.Bspline.eval(obj.ctrlPts, 'curve', s, divs);
    case 2
        F = obj.Bspline.eval(obj.ctrlPts, 'curve', s);
    case 1
        F = obj.Bspline.eval(obj.ctrlPts, 'curve');
end
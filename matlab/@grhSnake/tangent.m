function F = tangent(obj, s, divs)

if nargin > 2
    F = obj.Bspline.tangent(obj.ctrlPts, s, divs);
else
    if nargin > 1
        F = obj.Bspline.tangent(obj.ctrlPts, s);
    else
        F = obj.Bspline.tangent(obj.ctrlPts);
    end
end
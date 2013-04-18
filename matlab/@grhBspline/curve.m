function F = curve(obj, ctrlPts, s)
%
%     F = curve(obj, ctrlPts)
%     F = curve(obj, ctrlPts, s) 
%
%     F = curve(obj, ctrlPts)
%     Evaluate the spline function weighted by ctrlPts over entire range
%     
%     F = curve(obj, ctrlPts, s) 
%     evaluate at s if s >=0
%     otherwise evaluation over range of Bspline
%     at -s equally spaced intervals

% pass call on to general evaluation function
switch nargin
    case 2
        F = eval(obj, ctrlPts, 'curve');
    case 3
        F = eval(obj, ctrlPts, 'curve', s);
end
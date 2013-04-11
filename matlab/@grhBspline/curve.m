function F = curve(obj, ctrlPts, s)
%
%     F = curve(obj, ctrlPts, s, divs)
%
%     Evaluate the spline function weighted by ctrlPts
%     s can be an individual value
%     otherwise evaluation over range of Bspline
%     with number of divisions divs

    % pass call on to general evaluation function
    switch nargin
        case 2
            F = eval(obj, ctrlPts, 'curve');
        case 3
            F = eval(obj, ctrlPts, 'curve', s);
    end
function F = tangent(obj, ctrlPts, s)
%
%     F = tangent(obj, ctrlPts, s, divs)
%
%     Evaluate tangent to spline function weighted by ctrlPts
%     s can be an individual value
%     otherwise evaluation over range of Bspline
%     with number of divisions divs

    % pass call on to general evaluation function
    switch nargin
        case 2
            F = eval(obj, ctrlPts, 'tangent');
        case 3
            F = eval(obj, ctrlPts, 'tangent', s);
    end
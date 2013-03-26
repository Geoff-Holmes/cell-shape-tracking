function F = curve(obj, ctrlPts, s, divs)
    % evaluate the spline function weighted by ctrlPts
    % s can be an individual value
    % otherwise evaluation over range of Bspline

    % make sure control points are correct size column vector
    assert(length(ctrlPts)==obj.L)
    if size(ctrlPts, 1) == 1
        ctrlPts = reshape(ctrlPts, obj.L, 1);
    end
    % user set number of test points
    if nargin < 4
        divs = 100*obj.L;
    end
    % test for single user set test point
    if nargin < 3 || s == 0
        s = linspace(0, obj.L, divs);
        F = zeros(divs,1);
        ind = 1;
        for k = 1:obj.L
            temp = s(s>=k-1 & s<k)-k+1;
            temp = repmat(temp', 1, obj.d);
            pows = repmat(0:obj.d-1, length(temp), 1);
            temp = temp.^pows;
            temp = temp * obj.BS * obj.G(:,:,k) * ctrlPts;
            Ntemp = length(temp);
            F(ind:ind+Ntemp-1)    = temp;
            ind = ind + Ntemp;
        end
        F(end) = F(1);
    else
        display('code for single value missing')
    end
end
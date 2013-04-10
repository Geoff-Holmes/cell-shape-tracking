function F = tangent(obj, ctrlPts, s, divs)
%
%     F = tangent(obj, ctrlPts, s, divs)
%
%     Evaluate tangent to spline function weighted by ctrlPts
%     s can be an individual value
%     otherwise evaluation over range of Bspline
%     with number of divisions divs

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
    if nargin < 3 || s < 0 
        s = linspace(0, obj.L, divs);
        F = zeros(divs,1);
        ind = 1;
        for k = 1:obj.L
            temp = s(s>=k-1 & s<k)-k+1;
            % first two columns always 0s and 1s
            temp = repmat(temp', 1, obj.d-2);
            pows = repmat(1:obj.d-2, length(temp), 1);
            fac = repmat(2:obj.d-1, length(temp), 1);
            temp = [repmat([0 1], size(temp, 1), 1) temp.^pows];
            % differentiation factors needed for cols 3 on
            temp(:,3:end) = temp(:,3:end) .* fac;
            % evaluate for this group and store
            temp = temp * obj.BS * obj.G(:,:,k) * ctrlPts;
            Ntemp = length(temp);
            F(ind:ind+Ntemp-1)    = temp;
            ind = ind + Ntemp;
        end
    else
        % find which span is needed
        k = floor(s);
        k = obj.bsig(k+1);
        % get s above span floor
        s = s - floor(s);
        % get powers of s
        s = s .^ (0:obj.d-2);
        s = [0 s];
        % apply differentiation factors
        s = s .* 0:obj.d-1;
        % calculate function at s
        F = s * obj.BS * obj.G(:,:,k) * ctrlPts;
    end
end
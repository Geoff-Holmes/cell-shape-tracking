function [F, s] = eval(obj, ctrlPts, order, s)

%     [F, s] = eval(obj, ctrlPts, order, s)
%
%     evaluate at s the given order of the Bspline weighted by ctrlPts
%     if s = -1, if at every not point of the Bspline
%     if s is any other negative integer evaluation is over entire range 
%     at -s equally spaced divisions.
%     order can take the values:
%     'curve' - evaluation the function
%     'tangent' - evaluate the tangent vector
%     'normal' - evaluate the normal vector
%      all returned values are complex number representations of vectors

if isa(ctrlPts, 'grhSnake')
    ctrlPts = ctrlPts.ctrlPts;
end

if nargin < 3
    order = 'curve';
else
    try
        assert(strcmp(order, 'curve') ...
            || strcmp(order, 'tangent') ...
            || strcmp(order, 'normal'))
    catch
        display('The only valid eval order options are curve / tangent / normal.')
        return
    end
end

% make sure control points are correct size column vector
assert(length(ctrlPts)==obj.L)
if size(ctrlPts, 1) == 1
    ctrlPts = reshape(ctrlPts, obj.L, 1);
end

% default number of evaluation points
divs = 100*obj.L;

if nargin == 4
    if s >= 0
        % single user defined evaluation point
        % find which span is needed
        k = floor(s);
        k = obj.bsig(k+1);
        % get s above span floor
        s = s - floor(s);
        if strcmp(order, 'curve')
            % get powers of s
            s = s .^ (0:obj.d-1);
        else
            % get powers of s
            s = s .^ (0:obj.d-2);
            s = [0 s];
            % apply differentiation factors
            s = s .* (0:obj.d-1);
        end 
        % calculate function at s
        F = s * obj.BSG{k} * ctrlPts;
        if strcmp(order, 'normal')
            F = 1i * F;
        end
        return
    else
        if s == -1
            divs = obj.L+1;  % evaluate at all knots
        else
            divs = -s;
        end
    end
end

% evaluation of entire range    
s = linspace(0, obj.L, divs);
F = zeros(divs-1,1);
ind = 1;
for k = 1:obj.L
    temp = s(s>=k-1 & s<k)-k+1;
    if strcmp(order, 'curve')
        temp = repmat(temp', 1, obj.d);
        pows = repmat(0:obj.d-1, size(temp,1), 1);
        temp = temp.^pows;
    else
        % first two columns always 0s and 1s
        temp = repmat(temp', 1, obj.d-2);
        pows = repmat(1:obj.d-2, size(temp,1), 1);
        % differentiation factors needed for cols 3 on
        fac = repmat(2:obj.d-1, size(temp, 1), 1);
        temp = [repmat([0 1], size(temp, 1), 1) fac.*temp.^pows];
    end
    % evaluate for this group and store
    temp = temp * obj.BSG{k} * ctrlPts;
    Ntemp = size(temp, 1);
    F(ind:ind+Ntemp-1) = temp;
    ind = ind + Ntemp;
end

if strcmp(order, 'normal')
    F = 1i * F;
end


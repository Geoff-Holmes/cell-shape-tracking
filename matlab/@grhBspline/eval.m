function F = eval(obj, ctrlPts, order, s)

%     F = tangent(obj, ctrlPts, s)
%
%     Evaluate tangent to spline function weighted by ctrlPts
%     s can be an individual value
%     s if negative defines number of division over entire range

    if isa(ctrlPts, 'grhSnake')
        ctrlPts = ctrlPts.ctrlPts;
    end

    % make sure control points are correct size column vector
    assert(length(ctrlPts)==obj.L)
    if size(ctrlPts, 1) == 1
        ctrlPts = reshape(ctrlPts, obj.L, 1);
    end
    
    % default number of evaluation points
    divs = 100*obj.L;
    
    if nargin = 4
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
                s = s .* 0:obj.d-1;
            end 
            % calculate function at s
            F = s * obj.BS * obj.G(:,:,k) * ctrlPts;
            if strcmp(order, 'normal')
                F = 1i * F;
            end
            return
        else
            divs = -s;
        end
    end
    
    % evaluation of entire range    
    s = linspace(0, obj.L, divs);
    F = zeros(divs,1);
    ind = 1;
    for k = 1:obj.L
        temp = s(s>=k-1 & s<k)-k+1;
        if strcmp(order, 'curve')
            temp = repmat(temp', 1, obj.d);
            pows = repmat(0:obj.d-1, length(temp), 1);
            temp = temp.^pows;
        else
            % first two columns always 0s and 1s
            temp = repmat(temp', 1, obj.d-2);
            pows = repmat(1:obj.d-2, length(temp), 1);
            fac = repmat(2:obj.d-1, length(temp), 1);
            temp = [repmat([0 1], size(temp, 1), 1) temp.^pows];
            % differentiation factors needed for cols 3 on
            temp(:,3:end) = temp(:,3:end) .* fac;
        end
        % evaluate for this group and store
        temp = temp * obj.BS * obj.G(:,:,k) * ctrlPts;
        Ntemp = length(temp);
        F(ind:ind+Ntemp-1)    = temp;
        ind = ind + Ntemp;
    end

    if strcmp(order, 'normal')
        F = 1i * F;
    end

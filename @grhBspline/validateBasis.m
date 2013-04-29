function TF = validateBasis(obj,plt)
    % check that basis normalises and show
    ctrlPts = eye(obj.L);
    for i = 1:obj.L
        F(:,i) = obj.curve(ctrlPts(i,:));
    end
    F(:,end+1) = obj.curve(ones(1,obj.L));
    if nargin > 1
        figure;
        plot(F)
        ylim([0 1.1])
    end
    TF = min(F(:,end)>.99999999);
end
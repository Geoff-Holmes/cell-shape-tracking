function c = getCentroid(obj, Q)

% get centroid of shape described by spline curve with control points Q
% this centroid follows the simple calculation of Blake p 
if isa(Q, 'grhSnake')
    Q = Q.ctrlPts;
end

Onex = [ones(obj.L, 1)];
Oney = Onex * 1i;

c = obj.innerProduct(Onex, Q) + 1i * obj.innerProduct(Oney, Q);



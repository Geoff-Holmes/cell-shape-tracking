function c = getCentroid(obj, Q)

% get centroid of shape described by spline curve with control points Q
% this centroid follows the simple calculation of Blake p 63
% NB this is not invariant to reparamatrisation and in a particular there a
% discrepancy between the centroid calcuated this way and the the centroid
% of the original fitted boundary data

if isa(Q, 'grhSnake')
    Q = Q.ctrlPts;
end

Onex = [ones(obj.L, 1)];
Oney = Onex * 1i;

c = obj.innerProduct(Onex, Q) + 1i * obj.innerProduct(Oney, Q);



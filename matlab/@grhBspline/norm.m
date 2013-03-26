function nrm = norm(obj, Q)

% calculate norm of spline curve with control points Q

nrm = obj.innerProduct(Q, Q);
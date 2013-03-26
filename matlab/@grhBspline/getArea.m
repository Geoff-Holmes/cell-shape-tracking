function A = getArea(obj, Q)

% get area of spline curve with control points Q
% Blake p. 65

Qx = real(Q);
Qy = imag(Q);

Z = zeros(size(obj.MA));

A = [Qx' Qy'] * [Z obj.MA; -obj.MA Z] * [Qx; Qy] / 2;

% errors in Blake got central A matrix wrong and omitted factor of /2
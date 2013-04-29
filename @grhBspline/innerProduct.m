function ip = innerProduct(obj, Q1, Q2)

% calculate the Bspline curve inner product between curves given by control
% points Q1 and Q2

Q1x = real(Q1);
Q1y = imag(Q1);
Q2x = real(Q2);
Q2y = imag(Q2);

ip = Q1x' * obj.MB * Q2x + Q1y' * obj.MB * Q2y;
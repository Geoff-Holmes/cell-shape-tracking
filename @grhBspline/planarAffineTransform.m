function [Q, X] = planarAffineTransform(obj, Q0, X_trans, scl, rot)

% based on Blake p76ff

% either pass in deformation vector X or translation, scaling and rotation
if nargin == 3 && length(X_trans) == 6
    X = X_trans;
else
    trans = X_trans;
    if length(trans)==1
        trX = real(trans);
        trY = imag(trans);
    else
        trX = trans(1);
        trY = trans(2);
    end
    sclX = scl(1);
    if length(scl) > 1
        sclY = scl(2);
    else
        sclY = scl;
    end
    X = [trX; trY; sclX*(cos(rot)-1); sclY*(cos(rot)-1); -sin(rot); sin(rot)];
end

Qx = real(Q0);
Qy = imag(Q0);
Z = zeros(obj.L, 1);
I = ones(size(Z));

W = [I Z Qx Z Z Qy; Z I Z Qy Qx Z];

Q = W * X + [Qx; Qy];

Q = Q(1:obj.L) + 1i*Q(obj.L+1:end);
    

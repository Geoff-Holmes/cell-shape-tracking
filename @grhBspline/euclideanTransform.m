function Q = euclideanTransform(obj, Q0, trans, scl, rot)

% return control points Q for transform of Q0 by translation, scaling and
% rotation passed.
% not currently in keeping with Blake were X represents a deformation from
% the original image in that case Q = W*X + Q0

if numel(trans) > 1
    trans = trans(1) + 1i * trans(2);
end

W = [ones(obj.L, 1) Q0];

X = [trans; scl * exp(1i*rot)];

Q = W * X;
function Q = transform(obj, X)

% Blake Eqn(4.1)
Q = obj.W * X + [obj.Qx; obj.Qy];

% return to complex
Q = Q(1:obj.Bspline.L) + 1i*Q(obj.Bspline.L+1:end);
Q = grhSnake(Q, obj.Bspline);
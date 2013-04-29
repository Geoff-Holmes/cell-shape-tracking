function X = project(obj, Q)

if isa(Q, 'grhSnake'), Q = Q.ctrlPts; end

% apply Blake Eqn(6.1)
X = obj.Wplus * ...
     ([real(Q); imag(Q)] - [obj.Qx; obj.Qy]);
   
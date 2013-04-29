function p = plotOffset(obj, offset, colour)

if nargin ==1, colour = 'b'; end

% evaluate curve
F = obj.Bspline.eval(obj.ctrlPts, 'curve');
% close the curve
F(end+1) = F(1);

F = F + offset;

p = plot(F, colour);
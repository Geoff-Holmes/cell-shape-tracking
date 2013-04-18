function p = plot(obj, colour)

if nargin ==1, colour = 'b'; end

% evaluate curve
F = obj.Bspline.curve(obj.ctrlPts);
% close the curve
F(end+1) = F(1);

p = plot(F, colour);
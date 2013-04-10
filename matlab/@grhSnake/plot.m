function plot(obj, colour)

if nargin ==1, colour = 'b'; end
plot(obj.Bspline.curve(obj.ctrlPts), colour)
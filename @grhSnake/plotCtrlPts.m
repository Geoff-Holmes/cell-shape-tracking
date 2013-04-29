function plotCtrlPts(obj, colour)

% plot the snakes control points

if nargin <2
    colour = 'r';
end

plot(obj.ctrlPts, colour, 'marker', '+', 'lineStyle', 'none')
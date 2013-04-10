function plot(obj, i)

% plot the cell outline at time i using basis Bspline
if nargin > 1
    plot(obj.Bspline.curve(obj.ctrlPts{i}))
else
    hold on
    for i = 1:length(obj.ctrlPts)
        plot(obj.Bspline.curve(obj.ctrlPts{i}))
    end
end
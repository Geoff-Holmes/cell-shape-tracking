function cellPlot(obj, i)

% plot the cell outline at time i using basis Bspline
if nargin > 1
    plot(obj.Bspline.curve(obj.ctrlPts{i}))
else
    hold on
    for i = 1:length(obj.Bspline)
        plot(obj.Bspline.curve(obj.ctrlPts{i}))
    end
end
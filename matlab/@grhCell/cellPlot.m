function cellPlot(obj, i)

% plot the cell outline at time i using basis Bspline

plot(obj.Bspline.curve(obj.ctrlPts{i}))
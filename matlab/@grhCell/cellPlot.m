function cellPlot(obj, i, Bspline)

% plot the cell outline at time i using basis Bspline

plot(Bspline.curve(obj.ctrlPts{i}))
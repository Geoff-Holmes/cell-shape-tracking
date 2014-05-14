function trackShapePlot(obj, track)

%trackShapePlot(obj, track)
%
% show whole track in coordinate and shape space

thisTrack = obj.cells(track);
T = length(thisTrack.snake);

figure
subplot(1,2,2)
hold on
subplot(1,2,1)
hold on
% trace out centroid
plot([thisTrack(:).centroid], 'r')

for i = 1:10:T
    subplot(1,2,1)
    thisTrack.snake(i).plot
    subplot(1,2,2)
    plotData = thisTrack.snake(i).shapeDescriptor;
    plot(plotData(1), plotData(2), 'o')
end


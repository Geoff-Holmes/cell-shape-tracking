function p = plotLameAll(obj,fig)
if nargin ==2
    figure = fig;
end

for iFrame = 1:length(obj.lameBounds)
    cla;
    hold on;
    for iCell = 1:size(obj.tracks.frames(iFrame).bounds,2)
        plot(obj.tracks.frames(iFrame).bounds{iCell}','b')
    end
    
    for iLame = 1:size(obj.lameBounds{iFrame},2)
        plot(obj.lameBounds{iFrame}{iLame}','r')
    end
    set(gcf,'color',[0,0,0]);
    axis off;
    pause;
end






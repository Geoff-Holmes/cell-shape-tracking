function p = plotLameAll(obj,fig)
if nargin ==2
    figure = fig;
end

for iFrame = 1:length(obj.lameBounds)
    cla;
    hold on;
    for iCell = 1:size(obj.tracks.frames(iFrame).bounds,2)
        plot(obj.tracks.frames(iFrame).bounds{iCell},'b')
    end
    
    for iC = 1:length(obj.lameBounds{iFrame})
        for iF = 1:length(obj.lameBounds{iFrame}{iC})
            plot(obj.lameBounds{iFrame}{iC}{iF},'r')
        end
    end
    set(gcf,'color',[0,0,0]);
    axis off;
    pause;
end






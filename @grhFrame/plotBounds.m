function plotBounds(obj, iCell, fig, sp)
    
    if nargin > 2
        figure(fig); hold on;
        if nargin > 3
            subplot(sp); hold on;
        end
%     else
%         figure; hold on;
    end
    
    if iCell == 0 
        for i = 1:length(obj.bounds)
            plot(obj.bounds{i});
        end
    else
        plot(obj.bound{iCell})
end

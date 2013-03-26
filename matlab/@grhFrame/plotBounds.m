function plotBounds(obj, fig, sp)
    
    if nargin > 1
        figure(fig); hold on;
        if nargin > 2
            subplot(sp); hold on;
        end
%     else
%         figure; hold on;
    end
    
    for i = 1:length(obj.bounds)
        plot(obj.bounds{i});
    end
end

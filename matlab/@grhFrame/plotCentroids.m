function plotCentroid(obj, fig, sp)
    
    if nargin > 1
        figure(fig); hold on;
        if nargin > 2
            subplot(sp); hold on;
        end
    else
        figure; hold on;
    end

    plot(obj.centroids, 'r+')
end
function obj = iterate(obj)

%     figure; sp1 = subplot(1,2,1); sp2 = subplot(1,2,2);

for k = 2:obj.DataL
    % get observation info from the next frame
    obj.frames{k} = obj.ImageHandler.getFrame(obj.Data{k});

%         obj.frames{k}.plotBounds(gcf,sp1);
%         obj.frames{k}.plotCentroids(gcf,sp1);

    % get distances of all possible position jumps last frame to this
    obj.centroidDistances{k-1} ...
        = abs(dist(obj.frames{k-1}.centroids', obj.frames{k}.centroids));
    
    for i = obj.liveTracks
        prediction{i} = obj.Model.A * obj.cells{i}.ctrlPts{k-1};
    end
    
end
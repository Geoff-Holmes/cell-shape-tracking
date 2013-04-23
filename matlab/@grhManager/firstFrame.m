function obj = firstFrame(obj)
    
% get observation data from first frame
obj.frames{1} = obj.ImageHandler.getFrame(obj.Data{1});

for i = 1:obj.frames{1}.cellCount
    ctrlPts = obj.Bspline.dataFit(obj.frames{1}.bounds{i});
    % create cell object for each observed cell
    Cells{i} = grhCell(i, 1, obj.Bspline, ctrlPts, obj.Model.W, obj.frames{1}.centroids(i), i);
end

% attach cells to manager
obj.cells = Cells;

% initiate total track count
obj.Ntracks = obj.frames{1}.cellCount;
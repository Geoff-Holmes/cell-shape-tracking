function obj = firstFrame(obj)
    
% get observation data from first frame
obj.frames{1} = obj.ImageHandler.getFrame(obj.Data{1});

for i = 1:obj.frames{1}.cellCount
    ctrlPts = obj.Bspline.dataFit(obj.frames{1}.bounds{i});
    % create cell object for each observed cell
    Cells{i} = grhCell(i, 1, obj.Bspline, ctrlPts, eye(obj.Bspline.L), obj.frames{1}.centroids(i), i);
end

% attach cells to manager
obj.cells = Cells;

% initiate live track list
obj.liveTracks = 1:obj.frames{1}.cellCount;
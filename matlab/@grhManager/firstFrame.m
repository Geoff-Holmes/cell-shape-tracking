function obj = firstFrame(obj)
    
% get observation data from first frame and initialise corresponding cell
% objects using least squares fit to construct Bspline control points from
% the raw boundaries

obj.frames{1} = obj.ImageHandler.getFrame(obj.Data{1});

for i = 1:obj.frames{1}.cellCount
    [ctrlPts, ~, Cmatrix] = obj.Bspline.dataFit(obj.frames{1}.bounds{i});
    % create cell object for each observed cell
    Cells{i} = grhCell(i, 1, obj.Bspline, ctrlPts, obj.Model.W, ...
        obj.frames{1}.centroids(i), i, ...
        [ctrlPts; zeros(obj.Bspline.L, 1)], Cmatrix);
end

% attach cells to manager
obj.cells = Cells;

% initiate total track count
obj.Ntracks = obj.frames{1}.cellCount;
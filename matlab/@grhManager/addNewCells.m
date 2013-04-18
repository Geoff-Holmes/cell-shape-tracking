function obj = addNewCells(obj, Tframe, thisFrameObs, newCellObsIDs)
    
% number of new cells
Nnew = length(newCellObsIDs);
% loop over unallocated cell obs
for i = 1:Nnew
    % get initial ctrlPts for each one
    ctrlPts = obj.Bspline.dataFit(thisFrameObs.bounds(newCellObsIDs(i)));
    % create cell object for each observed cell
    Cells{i} = ...
        grhCell(obj.Ntracks + i, Tframe, obj.Bspline, ...
        ctrlPts, eye(obj.Bspline.L), ...
        thisFrameObs.centroids(newCellObsIDs(i)), newCellObsIDs(i));
end

% attach cells to manager
obj.cells(end+1:end+Nnew) = Cells;

% initiate total track count
obj.Ntracks = obj.Ntracks + Nnew;
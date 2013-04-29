function [obj, newIDs] ...
    = addNewCells(obj, Tframe, thisFrameObs, newCellObsInds)

% add cells that are considered new (can't be allocated to existing tracks)
% to the list of cells thus initiating a potential new track
    
% number of new cells
Nnew = length(newCellObsInds);
% loop over unallocated cell obs
for i = 1:Nnew
    % get initial ctrlPts for each one
    [ctrlPts, ~, Cmatrix] ...
        = obj.Bspline.dataFit(thisFrameObs.bounds{newCellObsInds(i)});
    % create cell object for each observed cell
    Cells{i} = ...
        grhCell(obj.Ntracks + i, Tframe, obj.Bspline, ...
        ctrlPts, eye(obj.Model.Sdim), ...
        thisFrameObs.centroids(newCellObsInds(i)), newCellObsInds(i), ...
        [ctrlPts; zeros(obj.Bspline.L, 1)], Cmatrix);
end
% nObs = length(thisFrameObs.bounds)

% attach cells to manager
obj.cells(end+1:end+Nnew) = Cells;
% return new cell IDs
newIDs = obj.Ntracks + (1:Nnew);
% update total track count
obj.Ntracks = obj.Ntracks + Nnew;


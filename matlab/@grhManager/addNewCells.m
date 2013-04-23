function [obj, newIDs] ...
    = addNewCells(obj, Tframe, thisFrameObs, newCellObsInds)
    
% number of new cells
Nnew = length(newCellObsInds);
% loop over unallocated cell obs
for i = 1:Nnew
    % get initial ctrlPts for each one
    ctrlPts = obj.Bspline.dataFit(thisFrameObs.bounds{newCellObsInds(i)});
    % create cell object for each observed cell
    Cells{i} = ...
        grhCell(obj.Ntracks + i, Tframe, obj.Bspline, ...
        ctrlPts, eye(obj.Model.Sdim), ...
        thisFrameObs.centroids(newCellObsInds(i)), newCellObsInds(i));
end
% nObs = length(thisFrameObs.bounds)

% attach cells to manager
obj.cells(end+1:end+Nnew) = Cells;
% return new cell IDs
newIDs = obj.Ntracks + (1:Nnew);
% update total track count
obj.Ntracks = obj.Ntracks + Nnew;


function obj = iterate(obj, iCell, plt)

%     iterate through each frame of data from the second onwards and get 
%     the frame info - cell outlines and centroids
%     Also track cell iCell from the first frame

    if nargin > 2 && plt
        figure; sp1 = subplot(1,2,1); sp2 = subplot(1,2,2);
    end
    
    liveTracks    = 1:obj.Ntracks;
    liveCentroids = obj.frames{1}.centroids;

for k = 2:obj.DataL
%     pause()
    k
        
    % get number of live tracks
    NliveTracks = length(liveTracks);
    
    % flags for track live on / remove
    flagTracksLive = ones(1, NliveTracks);
    
    % get observation info from the next frame
    obj.frames{k} = obj.ImageHandler.getFrame(obj.Data{k});

    if nargin > 2 && plt
        obj.frames{k}.plotBounds(gcf,sp1);
        obj.frames{k}.plotCentroids(gcf,sp1);
    end
    
    % get correspondence vector according to chosen option 1 / 2
    [Crspnd, newCellInds] = obj.corresponder(...
        liveCentroids, obj.frames{k}.centroids, obj.maxMoveThresh, 1);

    try
    assert(NliveTracks == length(Crspnd));
    catch exAssert
    end
    
    
    % loop over live tracks
    for iCell = 1:NliveTracks
        
        if Crspnd(iCell) == 0 % track has ended
%             liveTracks(iCell)
            flagTracksLive(iCell) = 0;
        else
            try
            % get 'correct' cyclic permutation of new boundary obs 
            [newBound, centroidShift] ...
                = obj.getNewObsBoundary(k, liveTracks(iCell), Crspnd(iCell));
            catch exCallGetNewObsBoundary
                exCallGetNewObsBoundary
            end
            % construct C matrix
            C = obj.Bspline.getCmatrix(newBound, obj.Model.Sdim);
            
            % construct current state augmented with velocities if needed
            currentState = zeros(obj.Model.Sdim, 1);
            currentState(1:obj.Bspline.L) ...
                = obj.cells{liveTracks(iCell)}.getSnakeT(k-1).ctrlPts;
            if obj.Model.Sdim > obj.Bspline.L
                currentState(obj.Bspline.L+1:obj.Model.Sdim) ...
                    = obj.cells{liveTracks(iCell)}.getCtrlVelsT(k-1);
            end   

        %     Xnew = Filter(X0, Cov, Obs, ObsMat)
            [Xnew, ~, Qnew] = ...
                obj.Model.Filter(currentState, ...
                obj.cells{liveTracks(iCell)}.getCovarT(k-1), ...
                newBound, C);

            % add properties of the new observation to this cell
            obj.cells{liveTracks(iCell)}.addObservation...
                (Xnew(1:obj.Bspline.L), Qnew, ...
                obj.frames{k}.centroids(Crspnd(iCell)), ...
                Crspnd(iCell), centroidShift, ...
                Xnew(obj.Bspline.L+1:obj.Model.Sdim), ...
                C(:, 1:obj.Bspline.L));
        end
    end
    
    % tidy up for tracks that have ended
    liveTracks = liveTracks(find(flagTracksLive));
    liveCentroids = liveCentroids(find(flagTracksLive));
    
    % create new cells / tracks for unallocated observations
    if ~isempty(newCellInds)
%         newCellInds
        [obj, newCellIDs] = addNewCells(obj, k, obj.frames{k}, newCellInds);
%         newCellIDs
        liveTracks = [liveTracks newCellIDs];
        liveCentroids = [liveCentroids obj.frames{k}.centroids(newCellInds)];
    end
    
    
end
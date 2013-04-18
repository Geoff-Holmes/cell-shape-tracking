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
    [Crspnd, newCellsIDs] = obj.corresponder(...
        liveCentroids, obj.frames{k}.centroids, 40, 1);

    assert(NliveTracks == length(Crspnd));
    
    % loop over live tracks
    for iCell = 1:NliveTracks
        
        if Crspnd(iCell) == 0 % track has ended
            flagTracksLive(iCell) = 0;
        else
            
            % get 'correct' cyclic permutation of new boundary obs 
            [newBound, centroidShift] ...
                = obj.getNewObsBoundary(k, iCell, Crspnd);
   
            % construct C matrix
            C = obj.Bspline.getCmatrix(newBound);

        %     Xnew = Filter(X0, Cov, Obs, ObsMat)
            [Xnew, ~, Qnew] = ...
                obj.Model.Filter(obj.cells{iCell}.snake(k-1).ctrlPts, ...
                obj.cells{iCell}.covariance{k-1}, ...
                newBound, C);

            % add properties of the new observation to this cell
            obj.cells{iCell}.addObservation...
                (Xnew, Qnew, obj.frames{k}.centroids(Crspnd(iCell)), Crspnd(iCell), centroidShift);
        end
    end
    
    % tidy up for tracks that have ended
    liveTracks = liveTracks(find(flagTracksLive));
    liveCentroids = liveCentroids(find(flagTracksLive));
    obj = addNewCells(obj, k, obj.frames{k}, newCellIDs);
end
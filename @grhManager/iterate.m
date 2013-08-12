function obj = iterate(obj, stopEarly)

%     iterate through each frame of data from the second onwards and get 
%     the frame info - cell outlines and centroids
%     Track all lives cells assigning new obs to them as appropriate
%     stopEarly forces a max number of iterations during debugging

% check for early stop option
if nargin == 2
    maxIteration = stopEarly;
else
    maxIteration = obj.DataL;
end
    
% initialise with data from frame 1
liveTracks    = 1:obj.Ntracks;
liveCentroids = obj.frames(1).centroids;
    
% progress reporter
m = msgbox(['Iteration 1 of ' num2str(maxIteration)], 'Progress');
set(findobj(m,'style','pushbutton'),'Visible','off')

% cleanup up routine to ensure msgbox closes
cleaner = onCleanup(@() close(m));
    
for k = 2:maxIteration
    
    % progress report
    set(findobj(m,'Tag','MessageBox'), ...
        'String', ['   Iteration ' num2str(k) ' of ' num2str(maxIteration)])
    drawnow()
            
    % get number of live tracks
    NliveTracks = length(liveTracks);
    
    % flags for track to-continue / be-removed all initially set continue
    flagTracksLive = ones(1, NliveTracks);
    
    % get observation info from the next frame
    obj.frames(k) = obj.ImageHandler.getFrame(obj.Data{k});
    
    % for association, update centroid information according to model
    L = obj.Bspline.L;
    % only do it if the prediction makes a difference
    if size(obj.Model.A, 2) > L && sum(sum(obj.Model.A(L+1:2*L,L+1:2*L)))>0
        for iCell = 1:NliveTracks
            % get state prediction
            temp = obj.Model.A * obj.cells(liveTracks(iCell)).states{end};
            % get position states only
            temp = temp(1:obj.Bspline.L);
            % calculate predicted centroid from predicted states
            liveCentroid(iCell) = obj.Bspline.getCentroid(temp);
        end
    end
    clear L temp
       
    % get correspondence vector according to chosen option 1 / 2
    [Crspnd, newCellInds] = obj.corresponder(...
        liveCentroids, obj.frames(k).centroids, obj.maxMoveThresh, 1);
    
%     try
%         assert(NliveTracks == length(Crspnd));
%     catch exAssert
%         exAssert
%     end

    % loop over live tracks
    for iCell = 1:NliveTracks
        
        if Crspnd(iCell) == 0 % track has ended
            % mark for removal
            flagTracksLive(iCell) = 0;
        else
            % get 'correct' cyclic permutation of new boundary obs 
            [newBound, centroidShift] ...
                = obj.getNewObsBoundary(k, liveTracks(iCell), Crspnd(iCell));
            
            % construct time varying observation C matrix
            C = obj.Bspline.getCmatrix(newBound, obj.Model.Sdim);
            
            % apply Kalman filter to get new states
        %     Xnew = Filter(X0, Cov, Obs, ObsMat)
            [Xnew, ~, Qnew] = ...
                obj.Model.Filter(obj.cells(liveTracks(iCell)).getStateT(k-1), ...
                obj.cells(liveTracks(iCell)).getCovarT(k-1), ...
                newBound, C);

            % add properties of the new observation to this cell
            obj.cells(liveTracks(iCell)).addObservation...
                (Xnew, Qnew, obj.frames(k).centroids(Crspnd(iCell)), ...
                Crspnd(iCell), centroidShift, C(:, 1:obj.Bspline.L));
        end
    end
    
    % tidy up by removing tracks that have ended
    liveTracks = liveTracks(find(flagTracksLive));
    liveCentroids = liveCentroids(find(flagTracksLive));
    
    % create new cell-track for each unallocated observations
    if ~isempty(newCellInds)
        [obj, newCellIDs] = addNewCells(obj, k, obj.frames(k), newCellInds);
        liveTracks = [liveTracks newCellIDs];
        liveCentroids = [liveCentroids obj.frames(k).centroids(newCellInds)];
    end
end

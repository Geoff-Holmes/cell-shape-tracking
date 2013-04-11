function obj = iterate(obj, iCell, plt)

%     iterate through each frame of data from the second onwards and get 
%     the frame info - cell outlines and centroids
%     Also track cell iCell from the first frame

    if nargin > 2 && plt
        figure; sp1 = subplot(1,2,1); sp2 = subplot(1,2,2);
    end

for k = 2:obj.DataL
    % get observation info from the next frame
    obj.frames{k} = obj.ImageHandler.getFrame(obj.Data{k});
    
    % new obs yet to be allocated
    newFrameCells = ones(1,obj.frames{k}.cellCount);

    if nargin > 2 && plt
        obj.frames{k}.plotBounds(gcf,sp1);
        obj.frames{k}.plotCentroids(gcf,sp1);
    end

%     % get distances of all possible position jumps last frame to this
%     % complex argument require transpose / conjugate for dist!
%     obj.centroidDistances{k-1} ...
%         = abs(dist(obj.frames{k-1}.centroids', obj.frames{k}.centroids));
    
    % get distance of iCell to all new cell centroids
    % warning dist requires a conjugate of initial complex value!
    obj.centroidDistances{k-1} ...
        = abs(dist(obj.cells{iCell}.centroid(k-1)', ...
              obj.frames{k}.centroids));

    % find closest possible new position for this cell
    [minD, ind] = min(obj.centroidDistances{k-1});

    % check if the cell failed to continue
    if minD > obj.maxMoveThresh
        k
        break
    end
    
    % get net movement of cell centroid
    centroidShift = obj.frames{k}.centroids(ind) ...
        - obj.cells{iCell}.getCentroid(k-1);
    
    % get start point of previous boundary
    p0 = obj.cells{iCell}.snake(k-1).curve(0)
    
    % get normal at start of previous boundary
    % in complex normal is i * tangent
    nrm0 = 1i * obj.cells{iCell}.snake(k-1).tangent(0);
    nrm0 = nrm0 / abs(nrm0);
    
    
    
    
    % construct C matrix
    C = obj.Bspline.getCmatrix(obj.frames{k}.bounds{ind});
    
%     Xnew = Filter(X0, Cov, Obs, ObsMat)
    [Xnew, ~, Qnew] = ...
        obj.Model.Filter(obj.cells{iCell}.snake(k-1).ctrlPts, ...
        obj.cells{iCell}.covariance{k-1}, ...
        obj.frames{k}.bounds{ind}, C);
    
    % add properties of the new observation to this cell
    obj.cells{iCell}.addObservation...
        (Xnew, Qnew, obj.frames{k}.centroids(ind), ind);
    
    

    
    

end
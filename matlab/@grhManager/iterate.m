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
    p0 = obj.cells{iCell}.snake(k-1).curve(0);
    
    % move start point with cell to new cell position in order to map
    % boundary starting points
    p0 = round(p0 + centroidShift);
    
    % get normal at start of previous boundary
    % in complex normal is i * tangent
    nrm0 = obj.cells{iCell}.snake(k-1).normal(0);
%     nrm0 = nrm0 / abs(nrm0);
    obj.cells{iCell}.snake(k-1).plotNormal(0);
    
    % prepare new obs boundary for searching
    newBound = obj.frames{k}.bounds{ind};
    newBoundI = sparse([imag(newBound); imag(p0)], [real(newBound); real(p0)],...
        [ones(length(newBound), 1); 0]);
   
%     figure; imshow(full(newBoundI))
%     hold; plot(p0, 'g+')
%     
%     pause()
    
    % get gradient of normal
    m = imag(nrm0)/real(nrm0);
    % counter for how many boundary points found on normal
    findCount = 0;
    newP = 0;
    % step number to be searched in each direction
    step = 0;
    if newBoundI(imag(p0), real(p0)) == 1
        findCount = findCount + 1;
        newP(findCount) = p0;
    end
    % want to find two
    while findCount < 2
        step = step + 1;
        % Bresnan line
        if abs(m) < 1
            deltax = [step round(step*m)];
        else
            deltax = [round(step/m) step];
        end
        plot(p0+deltax*[1;1i], 'g.')
        plot(p0-deltax*[1;1i], 'g.')
        % test for a successful find in both directions
        % positive direction
        if newBoundI(imag(p0)+deltax(2), real(p0)+deltax(1)) == 1
            findCount = findCount + 1;
            newP(findCount) = p0 + deltax * [1; 1i];
        end
        % negative direction
        if newBoundI(imag(p0)-deltax(2), real(p0)-deltax(1)) == 1
            findCount = findCount + 1;
            newP(findCount) = p0 - deltax * [1; 1i];
        end  
    end

    ind2 = find(newBound==newP(1));
    
    newBound = circshift(newBound, ind2-1);
   
    % construct C matrix
    C = obj.Bspline.getCmatrix(newBound);
    
%     Xnew = Filter(X0, Cov, Obs, ObsMat)
    [Xnew, ~, Qnew] = ...
        obj.Model.Filter(obj.cells{iCell}.snake(k-1).ctrlPts, ...
        obj.cells{iCell}.covariance{k-1}, ...
        newBound, C);
    
    % add properties of the new observation to this cell
    obj.cells{iCell}.addObservation...
        (Xnew, Qnew, obj.frames{k}.centroids(ind), ind);
    
    

    
    

end
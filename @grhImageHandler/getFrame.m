function frame = getFrame(obj, A)
    % get all cell boundaries and centroids above threshold area
    if issparse(A)
        A = full(A);
    end
    % get connected objects
    B = bwconncomp(A, 4);
    concomp = regionprops(B, 'centroid', 'PixelIdxList', 'Area');
    A = zeros(size(A));
    cc = 0;
    for i = 1:length(concomp)
        temp = concomp(i);
        if temp.Area > obj.minAreaThresh
            % reconstruct binary image for boundary finding
            A(temp.PixelIdxList) = 1;
            cc = cc+1;
            centroids(cc) = temp.Centroid * [1;1i];
        end
    end
    % get boundary
    [neutroBoundi, L] = bwboundaries(A,4,'noholes');
    % find boundary length
    for k = 1:cc
        bounds{k} = neutroBoundi{k}*[1i;1];
    end
    frame = grhFrame(bounds, centroids);
end
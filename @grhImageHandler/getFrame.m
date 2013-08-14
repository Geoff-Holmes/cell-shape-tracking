function frame = getFrame(obj, A)
    
% frame = getFrame(obj, A)
%
% get all cell boundaries and centroids above threshold area
% inbuilt centroid conflicts with Bspline centroid whereas mean of boundary
% seems to match it

if issparse(A)
    A = full(A);
end
% get connected objects
B = bwconncomp(A, 4);
%     concomp = regionprops(B, 'centroid', 'PixelIdxList', 'Area');
concomp = regionprops(B, 'PixelIdxList', 'Area');
% initialise reconstructed image
A = zeros(size(A));
% count number of admissable objects found
cc = 0;
for i = 1 :length(concomp)
    temp = concomp(i);
    if temp.Area > obj.minAreaThresh
        % add object to reconstructed binary image for boundary finding
        A(temp.PixelIdxList) = 1;
        cc = cc+1;
%             centroids(cc) = temp.Centroid * [1;1i];
    end
end
% get boundary
[neutroBoundi, L] = bwboundaries(A,4,'noholes');
for k = 1:cc
    bounds{k} = neutroBoundi{k}*[1i;1];
    centroids(k) = mean(bounds{k});
end
frame = grhFrame(bounds, centroids);
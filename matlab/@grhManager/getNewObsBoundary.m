function [newBound, centroidShift] ...
    = getNewObsBoundary(obj, k, iCell, Crspnd)

% get net movement of cell centroid
centroidShift = obj.frames{k}.centroids(Crspnd(iCell)) ...
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
%     obj.cells{iCell}.snake(k-1).plotNormal(0);

% prepare new obs boundary for searching
newBound = obj.frames{k}.bounds{Crspnd(iCell)};
newBoundI = sparse([imag(newBound); imag(p0)], [real(newBound); ...
    real(p0)], [ones(length(newBound), 1); 0]);

%     figure; imshow(full(newBoundI))
%     hold; plot(p0, 'g+')

% get gradient of normal
m = imag(nrm0)/real(nrm0);
% counter for how many boundary points found on normal
findCount = 0;
newP = 0;
% step number to be searched next in each direction
step = 0;
if newBoundI(imag(p0), real(p0)) == 1
    findCount = findCount + 1;
    newP(findCount) = p0;
end
% 'carry on search in this direction' flags
off1 = 1; off2 = 1;
% want to find two
while findCount < 2 && (off1 || off2)
    step = step + 1;
    % Bresnan line
    if abs(m) < 1
        deltax = [step round(step*m)];
    else
        deltax = [round(step/m) step];
    end
    % test for a successful find in both directions
    % positive direction
    if off1
        try
            if newBoundI(imag(p0)+deltax(2), real(p0)+deltax(1)) == 1
                findCount = findCount + 1;
                newP(findCount) = p0 + deltax * [1; 1i];
            end
%                 plot(p0+deltax*[1;1i], 'g.')
        catch Ex
            if strcmp(Ex.identifier, 'MATLAB:badsubscript')
                off1 = 0;
            else
                Ex; throwError
            end
        end
    end
    % negative direction
    if off2
        try
            if newBoundI(imag(p0)-deltax(2), real(p0)-deltax(1)) == 1
                findCount = findCount + 1;
                newP(findCount) = p0 - deltax * [1; 1i];
            end  
%                 plot(p0-deltax*[1;1i], 'g.')
        catch Ex
            if strcmp(Ex.identifier, 'MATLAB:badsubscript')
                off2 = 0;
            else
                Ex; throwError
            end
        end
    end
end

ind2 = find(newBound==newP(1));
newBound = circshift(newBound, length(newBound)-ind2+1);
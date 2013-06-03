function [C, newCellIDs] = correspondAuction(A, B, thresh, ~)

% [C, newCellIDs] = correspondAuction(A, B, thresh)
%
% inputs are two vectors A, B of cell centroid positions in complex form
% A represents exisiting tracks (from time k-1)
% B contains new measurements (from time k)
% also thresh is maximum distance a cell can move

% output is a correspondence vector C
% newCellIDs for obs not associated with any track
%
% eg C = [2 3 1] means that the cell-track corresponding to row 1 in A
% corresponds to that in row 2 of B


% get distances of all possible position jumps last frame to this
% complex arguments require transpose / conjugate for dist!
D = abs(dist(A', B));

% convert to necessary form
D(D > thresh) = Inf;
D = -D;

% C = auction(D);
% C = C(2,:);

[~,w,C] = auction_c(D');

newCellIDs = find(sum(w,2)==0);
function [winner, D] = NNauction(D)

% Calculate bids and determine winner for a nearest neighbour auction
% input: matrix of distances between old positions and new positions
% old correspond to rows, new to columns
% output: the row which wins the first column and the remaining distances
% matrix
% D entries above the threshold are already set to zeros so that the bids
% can be set to zero via last term in first line.
%
% This method is not yet working: results are not unique if the order of
% observations is changed

display(['This method is not yet working: results are not unique ' ...
    'if the order of observations is changed'])
throwError

% calculate bids
DD = 1 ./ D .* (D>0);
col1bids = DD(:,1) ./ sum(DD, 2);
% determine winner
[m, winner] = max(col1bids);
if m<=0, winner = []; end
% remove obs column
D = D(:, 2:end);
% dummy out track that has received allocation
D(winner, :) = -1;

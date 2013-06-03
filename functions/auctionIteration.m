function [P, A] = auctionIteration(P, A, a, epsilon) 

% single iteration of auction algorithm Bertsekas p 168f

% T all track indices
% M all list measurements
% P price vector
% A partial / final assignment
% a cost / value matrix

% get number of tracks and measurements
[T, M] = size(a);

% allow for empty current assignment
if numel(A)
    A1 = A(1,:);
else
    A1 = [];
end

% get unassigned tracks
I = setdiff(1:T, A1);

% BIDDING PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialise bid matrix
B = nan(T,M);

for i = 1:length(I)
    
    % get A(i) - the possible measurements to assign to track i
    inds = ~isinf(-a(I(i),:) );
    
    % get the max assignment value for track i and corr. index
    [v, j] = max(a(I(i),inds) - P(inds));
    
    % find the next best value
    inds(j) = 0;
    if sum(inds)
        w = max(a(I(i),inds) - P(inds));
    else
        w = v-1000;
    end
    
    % set B - next two lines equivalent
    B(I(i), j) = a(I(i),j) - w + epsilon;
    % B(I(i), j) = P(j) + v - w + epsilon;
    
end

% ASSIGNMENT PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j = 1:M
    
    % get best bid and bidder for measurement j
    [topBid, bidder] = max(B(:, j));
    
    % if there is a bidder
    if ~isnan(topBid)
        % increase price
        assert(topBid>P(j));
        P(j) = topBid;
        % remove beaten assignment
        if numel(A)
            A = A(:, A(2,:)~=j);
        end
        % add winning assignment
        A(:, end+1) = [bidder; j];
    end
        
end
    
    
    


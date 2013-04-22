function [C, newCellIDs] = correspondNN(A, B, thresh, type)

% [C, newCellIDs] = correspondNN(A, B, thresh)
%
% inputs are two vectors A, B of cell centroid positions in complex form
% also thresh is maximum distance a cell can move

% output is a correspondence vector C
% newCellIDs for obs not associated with any track
%
% eg C = [2 3 1] means that the cell-track corresponding to row 1 in A
% corresponds to that in row 2 of B

% initiliaze
C = zeros(1,length(A));  % correspondence vector
% set up flags, 1 if ...
% L1 = C;                  % tracks that have received new obs;
L2 = zeros(1,length(B)); % new obs have been allocated

% get distances of all possible position jumps last frame to this
% complex arguments require transpose / conjugate for dist!
D = abs(dist(A', B));
dummy = max(max(D)) + 1;
XX = D;

if nargin < 4, type = 1; end
switch type
    case 1
        % allocate new obs to tracks starting with the smallest possible cell jump
        % no sharing of new obs
        for i = 1:length(A)
            % get smallest poss jump
            m = min(min(XX));
            % find where this occurs
            [i, j] = find(XX == m);
            % if allowed make the allocation
            if m<=thresh, 
                C(i)  = j; 
%                 L1(i) = 1;
                L2(j) = 1;
            end
            % dummy out rows / cols that have been taken care of
            XX(i,:) = dummy;
            XX(:,j) = dummy;
        end

    case 2
        % allocate to each track the nearest obs if valid
        % sharing of obs allowed
        for i = 1:length(A)
            % get smallest poss jump
            [m, j] = min(XX(i,:));
            % if allowed make the allocation
            if m<=thresh, 
                C(i)  = j; 
%                 L1(i) = 1;
                L2(j) = 1;
            end
        end
        
    case 3
        % allocate tracks to obs using an auction
        % no sharing of obs
        % mark for omission distances over the threshold
        display('This method not reliable')
        throwError
%         D(D>thresh) = -1
%         cc = 0;
%         % continue while there are valid obs to allocate
%         while length(find(D>=0))
%             cc = cc + 1;
%             [j, D] = NNauction(D)
%             C(j) = cc
%             if length(j), L2(cc) = 1, end
%         end
            
    otherwise
        display('Invalid NN type')
        return
end

% also return unallocated obs
newCellIDs = find(~L2);


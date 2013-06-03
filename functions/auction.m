function [assignment, P] = auction(a)

% get number of tracks and measurements
[T, M] = size(a);

% initialise arbitrary prices with empty assignment Bertsekas p 168
P = zeros(1,M);
A = [];

% initialise
% C/5 <= delta <= C/2 Bert. p 174
delta = max(max(abs(a(abs(a)<Inf))))/3;
% 4 <= theta <= 10 Bert. p 174
theta = 7;
epsilon = max(1, delta);

k = 0;

a = a * (size(a,1) + 1);

% epsilon-Scaling Bert. p 172
while epsilon > 1
    
    A = [];

    while size(A,2) < min(M,T)
        
        % get update prices and (partial) assignment
        [P, A] = auctionIteration(P, A, a, epsilon);

    end

    k = k + 1;
    epsilon = max(1, delta/theta^k);
    
end
    
% order by track index
[~, inds] = sort(A(1,:));
assignment = A(:,inds);
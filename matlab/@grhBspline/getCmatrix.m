function C = getCmatrix(obj, boundary)

% get observation matrix which reconstructs observation from control points
% that are yet to be determined

nB = length(boundary);
% divide up Bspline domain around boundary
S = linspace(0, obj.L, nB+1);
% ensuring that start point does not appear twice
S = S(1:end-1);
% get powers for spline evaluation
p = 0:obj.d-1;
% intialise C matrix
C = zeros(nB, obj.L);

% counter for first row of next block of C to update
cc = 1;

% loop over Bspline spans
for i = 1:obj.L
    
    % get the points corresponding to pixels of this span
    s = S(S >= i-1 & S < i);
    % each point has its own row in the C matrix
    NnewRows = length(s);
    % calculate rows of C
    [pwr, s] = meshgrid(p, s);
    s = s .^ pwr;
    C(cc:cc+NnewRows-1, :) = s * obj.BSG{i};
    % update row pointer
    cc = cc + NnewRows;
    
end
    
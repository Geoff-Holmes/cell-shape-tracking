function [PC, info] = PCAonFDs(obj, Npcs, Npoints)

% use Principal component analysis to reduce dimension of Fourier
% Descriptors
% Npcs optionally set number of PCs to use

if nargin < 2
    Npcs = 3;
end
if nargin < 3
    Npoints = 33;
end

% get FDs
FD = obj.getAllFourierDescriptors(Npoints);
% get number of FDs
N = size(FD, 1);
% separate track / frame info
info = FD(:, 1:2);
FD = FD(:, 3:end);
% subtract mean
FD = bsxfun(@minus, FD, mean(FD));
% get eigenvectors and eigenvalues
[A, l] = eig(FD'*FD);

% sort by eigenvalues
[~, ind] = sort(diag(l));
ind = wrev(ind);
% and choose eigenvecs corresponding to Npcs largest
A = A(:, ind(1:Npcs));

% project onto chosen number of principal components
PC = FD * A;
    

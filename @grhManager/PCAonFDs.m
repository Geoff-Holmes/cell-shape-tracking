function PC = PCAonFDs(obj, Npcs)

% use Principal component analysis to reduce dimension of Fourier
% Descriptors
% Npcs optionally set number of PCs to use

if nargin == 1
    Npcs = 3;
end

% get FDs
FD = obj.getAllFourierDescriptors;
% get number of FDs
N = size(FD, 1);
% lose track / frame info
FD = FD(:, 3:end);
% get mean and replicate
mnFD = repmat(mean(FD), N, 1);
% subtract mean
FD = FD - mnFD;
% get eigenvectors and eigenvalues
[A, l] = eig(cov(FD));

% project onto chosen number of principal components
for i = 1:Npcs
    % extract eigenvector as row and replicate
    iEvec = repmat(A(:, end-i+1)', N, 1);
    % project all data onto this eigenvector
    PC(:,i) = sum(FD .* iEvec, 2);
end
    
    

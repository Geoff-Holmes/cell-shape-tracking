function [PC, info, Eigenvalues] = PCAonFDs(obj, Npcs, Npoints)

% [PC, info, Eigenvalues] = PCAonFDs(obj, Npcs, Npoints)
%
% use Principal component analysis to reduce dimension of Fourier
% Descriptors
% Npcs optionally set number of PCs to use
% Npoints sets numbers of points around shape boundaries
% PC is principal components of the shape data
% info contains track and track frame number

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
% output
Eigenvalues = wrev(sort(diag(l)));
% and choose eigenvecs corresponding to Npcs largest
A = A(:, ind(1:Npcs));

% project onto chosen number of principal components
PC = FD * A;
    
% figure; hold on;
% for i = unique(info(:,1))'
%     data = PC(info(:,1)==i, :);
%     try
%         plot3(data(:,1), data(:,2), data(:,3))
%         zlabel('pc 3')
%     catch
%         plot(data(:,1), data(:,2))
%     end
%     xlabel('pc 1')
%     ylabel('pc 2')
% end
% title('Cell tracks in shape space')
% figure
% for i = unique(info(:,1))'
%     data = PC(info(:,1)==i, :);
%     try
%          p = plot3(data(:,1), data(:,2), data(:,3), 'r');
%     catch
%         p = plot(data(:,1), data(:,2), 'r');
%     end
%     axis(obj.shapeDescriptorLims(1:end))
%     pause()
%     delete(p)
% end
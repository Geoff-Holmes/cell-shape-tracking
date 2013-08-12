function [absFD, FD] = fourierDescriptor(obj, Npoints, option)

% [absFD, FD] = fourierDescriptor(obj, Npoints, option)
%
% calculate fourier shape descriptor using MATLAB fft
% DC and second component removed since always 0 and 1
% Npoints specifies the number of boundary points to use
% option = centred 
%   see Gonzalez 'Digital Image Processing using Matlab' p458f

% get boundary points
if nargin == 1
    temp = obj.curve();
else
    temp = obj.curve(-Npoints);
end

if nargin == 3 && strcmp(option, 'centre')
    % centre the transform
    inds = 0:length(temp)-1;
    fac  = (-1).^inds;
    temp = fac' .* temp;
end

% close the curve
temp(end+1) = temp(1);

% transform
temp = fft(temp);
    
% make translation invariant by setting DC component to zero
% make scale invariant by normalising by second fourier component
% remove DC and second component
FD = temp(3:end)./abs(temp(2));

% get magnitude which is rotation / starting-point invariant
absFD = abs(FD);
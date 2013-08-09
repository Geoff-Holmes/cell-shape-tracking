function [absFD, FD] = fourierDescriptor(obj, Npoints)

% calculate fourier shape descriptor using MATLAB fft
% DC and second component removed since always 0 and 1

% get boundary points
if nargin == 1
    temp = obj.curve();
else
    temp = obj.curve(-Npoints);
end

% centre the transform
inds = 0:length(temp)-1;
fac  = (-1).^inds;
temp = fac' .* temp;

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
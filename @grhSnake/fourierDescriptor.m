function [absFD, FD] = fourierDescriptor(obj)

% calculate fourier shape descriptor using MATLAB fft

% get boundary points
temp = obj.curve(-33);
% close curve
temp(end+1) = temp(1);
temp = fft(temp);
    
% make translation invariant by removing DC component
temp = [0; temp(2:end)];

% make scale invariant by normalising by second fourier component
FD = temp./abs(temp(2));

% get magnitude which is rotation invariant
absFD = abs(FD)
function [FD, RlImFD, absFD] = fourierDescriptorCentroid(obj, Npoints)

% [FD, absFD] = fourierDescriptorCentroid(obj, Npoints)

if nargin == 1
    % default number
    Npoints = 33;
else
    if ~mod(Npoints, 2)
        Npoints = Npoints + 1;
    end
end

% get curve
C = obj.curve(-Npoints);

% get centroid distances
C = abs(C - mean(C));

% get un-normalised Fourier Descriptor
rawFD = fft(C);

% centroid distance is already translation and rotation invariant so only
% need to normalse for scale and starting point.

% best to divide by magnitude of largest magnitude component to reduce
% effects of noise
[maxAbs, indk] = max(abs(rawFD));
sclFD = rawFD / maxAbs;

% to normalise by starting point use the starting point which minimises the
% phase of the component with the largest magnitude.

% get phase of largest mag component
thK = angle(sclFD(indk));

% get base phase change for all possible start points of the shape
N = length(rawFD);
phs = (0:N-1) * 2*pi/N;

% get phase of component indk after all these starting point shifts 
thK = thK + (indk-1) * phs;

% find the starting point where component k has minimum phase in [0, 2pi)
[~, indSt] = min(mod(thK, 2*pi));

% normalise for start point and rotation
FD = sclFD .* exp(1j * (0:N-1)'*phs(indSt)); 

% output with Real and Imaginary parts separated
RlImFD = [real(FD); imag(FD)];

% get magnitude to output also
absFD = abs(FD); 
function [FD, RlImFD, absFD] = fourierDescriptorWallace(obj, Npoints)

% [FD, RlImFD, absFD] = fourierDescriptor(obj, Npoints)
%
% calculate fourier shape descriptor using MATLAB fft
%
% INPUTS:
% Npoints specifies the number of boundary points to use from the shape
% option = centred [this option now disabled]
%   see Gonzalez 'Digital Image Processing using Matlab' p458f
%
% OUTPUTS:
% FD     - the complex value Fourier Descriptors
% RlImFD - [real(FD); imag(FD)] for distance calculation
% absFD  - absolute values of the components
% 
% NB fft is fastest if #points is a power of 2 slowest if # has large prime
% factors.  However - for the normalisation here to work Npoints must be
% odd.
%
% to recover the original shape from centred Fourier descriptor
% use S = ifft(FD) 
% n.b. in the above FD is the complex centred Fourier descriptor not the
% absolute values of the components.

if nargin == 1
    % default number
    Npoints = 33;
else
    if ~mod(Npoints, 2)
        Npoints = Npoints + 1;
    end
end

% get un-normalised Fourier Descriptor
rawFD = fft(obj.curve(-Npoints));

% NORMALISATION: using a combination of Gonzalez 'Digital Image Processing 
% using Matlab' p458f, and Timothy P. Wallace†, Paul A. Wintz‡ 1980 
% "An efficient three-dimensional aircraft recognition algorithm using 
% normalized fourier descriptors"
% % 
% set DC to zero
rawFD(1) = 0;
% make scale invariant
% this assume a simple closed figure traced anti-clockwise in which case
% the second component has the largest magnitude
try
    [~, ind] = max(rawFD);
    assert(ind == 2);
catch
    display('Incorrectly composed boundary - Fourier descriptor normalisation compromised')
end
rawFD = rawFD / abs(rawFD(2));
% find index of second largest magnitude component
[~, indk] = max(abs(rawFD(3:end)));
indk = indk + 2;
% get phase of first and second largest components
th1 = angle(rawFD(2));
thk = angle(rawFD(indk));

% get angle required for rotation and start point to transform these two
% phases to zero which is the final normalisation requirement
A = -[1 1; 1 indk-1]\[th1; thk];
% get the multiple alternative start point angles
A2 = A(2) + (0:indk-2)*2*pi/indk;
% apply rotation and starting point alteration
k = 0:length(rawFD)-1;
FD{1} = rawFD .* exp(1i*(A(1) + k'*A(2)));
% compute the ambiguity resolving criteria
ARC(1) = sum(real(FD{1}).*abs(real(FD{1})));

for cc = 2:indk-1
    % get to next candidate start location
    FD{cc} = rawFD .* exp(1i*(A(1) + k'*A2(cc)));
    % compute the ambiguity resolving criteria
    ARC(cc) = sum(real(FD{cc}).*abs(real(FD{cc})));
end

% find the start point which maximises disambiguation criterion
[~, indARC] = max(ARC);
FD = FD{indARC};

% output with Real and Imaginary parts separated
RlImFD = [real(FD); imag(FD)];

% get magnitude to output also
absFD = abs(FD); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N = length(temp);
% % N must be even
% assert(~mod(N,2));
%     
% % normalisation following "An efficient three-dimensional aircraft 
% % recognition algorithm using normalized fourier descriptors"
% % Timothy P. Wallace†, Paul A. Wintz‡ 1980
% %
% % make translation invariant by setting DC component to zero
% % make scale invariant by normalising by largest fourier component
% temp(N/2+1) = 0;
% temp = temp / abs(temp(N/2+2));
% % find index of second largest magnitude component
% dummy = temp; dummy(N/2+2)=0;
% [~, indk] = max(abs(dummy));
% mk = abs(indk-N/2-1);
% 
% 
% 
% % transform to set these phases to zero
% i = -N/2+1:N/2; i = i';
% FD{1} = temp .* exp(1j*((i-indk)*th1 + (1-i)*thk)*(indk-1));
% % compute the ambiguity resolving criteria
% ARC(1) = sum(real(FD{1}).*abs(real(FD{1})));
% 
% for cc = 2:mk
%     % got to next candidate start location
%     FD{cc} = FD{cc-1} .* exp(1j*(i-1)*2*pi/mk);
%     % compute the ambiguity resolving criteria
%     ARC(cc) = sum(real(FD{cc}).*abs(real(FD{cc})));
% end
% 
% % find the version of FD which maximises disambiguation criterion
% [~, indARC] = max(ARC);
% FD = FD{indARC};
% 
% % get magnitude to output also
% absFD = abs(FD);    
    



% % get magnitude which is rotation / starting-point invariant
% % absFD = abs(FD); % but make the resulting descriptor not unique to the shape
% 
% % normalise phases for rotation / starting point invariance
% 
% % solve for rotation / starting point which transforms phase of 2nd and 3rd
% % descriptor; see Gonzalez / Winz 2nd edition (not in 3rd edition)
% % for cells it seems third component is not zero, hence we can use the
% % simpler approach of choose rotation and starting point which does this.
% A = [2 -1; -1 1]*[-th1; -th2]
% N = length(FD);
% 
% % apply rotation and starting point alteration
% k = 1:N;
% FD = FD .* exp(1i*(A(1) + k'*A(2)));


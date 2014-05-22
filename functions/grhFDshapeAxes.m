function [thetaMajor, thetaMinor] = grhFDshapeAxes(FD, plt)

% [thetaMajor, thetaMinor] = getFDshapeAxes(FD, plt)

% Inputs:
%   a complex point Fourier descriptor FD
%   option plt = 1 to plot
%
% Ouputs:
%   angles in radians of major and minor axis of basic ellipse of the shape
%   described by FD

% get the componenets which determine the basic ellipse
w = FD(2);
z = FD(end);

a = real(w);
b = imag(w);
c = real(z);
d = imag(z);

% the basic ellipse is given by:
% w*(cos(t) + j*sin(t)) + % z*(cos(t) - j*sin(t))
% this can be put in the form p(t) + j*q(t)
% and then f(theta) = p^2 + q^2 can be maximised to find t where the
% ellipse crosses the major axis
t = atan((a*d-b*c)/(a*c+b*d))/2;
% add in the second possible solution of the above
t = [t t+pi/2];

% t is not the angle of the axis but the value of the parameter so find the
% corresonding points
p = w*exp(1i*t)+z*exp(-1i*t);
% and the one on the major axis
[maxR, ind] = max(p);
% get the angle of this point which is therefore angle of the major axis
thetaMajor = angle(p(ind));
% get angle of minor axis
thetaMinor = thetaMajor + pi/2;
    
% plot if required
if nargin == 2 && plt
    
    figure;
    hold on
    % full shape
    S = ifft(FD);
    plot(S([1:end 1]), 'k');
    % basic ellipse
    S1 = ifft([FD(1:2) zeros(1,20) FD(end)]);
    plot(S1([1:end 1]), 'r');
    
    % data for axes
    mxS = 1.25 * max([abs(S1) abs(S)]); 
    cosMaj = cos(thetaMajor);
    sinMaj = sin(thetaMajor);
    mnS = 1.25 * max([min(abs(S1)) min(abs(S))]);
    cosMin = cos(thetaMinor);
    sinMin = sin(thetaMinor);
    % plot axes
    line(mxS * cosMaj * [-1;1], mxS * sinMaj * [-1;1])
    line(mnS * cosMin * [-1;1], mnS * sinMin * [-1;1])

    axis equal
    
end
    



clear all
close all

N = 3;
B = grhBspline(N, 4);

% impulse correlation matrix
ImpCorr = toeplitz([2 1 zeros(1, N-3) 1], [2 1 zeros(1, N-3) 1])/4;

% gallery('tridiag', ones(1,N-1), 2*ones(1,N), ones(1,N-1))/4;

% proportionality parameters
a = 0;  % impulse
b = .001; % attraction
c = 0.1; % repulstion
d = 0.9; % speed mean reversion

smax = 1;

% plot area
LL = 100;

while true
% initialise points on circle
th = linspace(0, 2*pi, N+1);
th = th(1:end-1);
x = exp(1i*th)';
% and velocities of points
v = zeros(N, 1);

plot(x, 'go');
hold on
S = grhSnake(B.dataFit(x), B);
plot(S, 'r');


while max(abs(x)) < LL
    
    Nimpulse = randi(floor(N/3));
    Indimpulse = randi(N, 1, Nimpulse);
    impulse = zeros(1,N);
    norms = S.normal(-1);
    norms = norms ./ abs(norms);
    impulse(Indimpulse) = - norms(Indimpulse);
    impulse = ImpCorr * impulse';
    
    d1 = circshift(x, 1) - x;
    d2 = circshift(x, -1) - x;
    
    F = a * impulse ...
        + b * (d1.*(d1 > 1) + d2.*(d2 > 1)) ...
        - c * (d1./abs(d1).^2.*(d1<.5) + d2./abs(d2).^2.*(d2<.5));
    
    v = v + F;
    speed = abs(v);
    v = v ./ speed;
    speed = speed + d * (smax - speed);
    v = v .* speed;
    
    x = x + v;
    
    plot(x, 'go');
    hold on
    S = grhSnake(B.dataFit(x), B);
    plot(S, 'r');
    S.plotNormal(-1);
    axis([-LL LL -LL LL])
    pause(0.2)
    hold off

end
end
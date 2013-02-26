clear all
close all

figure; hold on;

% basis function dimension
d = 3;
% powers needed for curve parameter
p = 0:d-1;

% number of spans
Nb = 5;

% span matrix for uniform 3rd order periodic basis functions
assert(d==3)
B = [.5 .5 0; -1 1 0; .5 -1 .5];

% first basis function supported on each span
bsig = [Nb-d+2:Nb 1:Nb-d+1];

% placement matrices
G = zeros(d, Nb, Nb);
for k = 1:Nb
    for i = 1:d
        % ith row picks up bsig+i-1th control point
        j = bsig(k)+i-1;
        % adjust for periodicity
        if j > Nb, j = j-Nb; end
        G(i, j, k) = 1;
    end
end

G
    
% calculate combined matrices
for i = 1:Nb
%     BG(:,:,i) = [B*G(:,:,i) zeros(d, Nb); zeros(d, Nb) B*G(:,:,i)];
    BG(:,:,i) = B*G(:,:,i);
end

BG

% now fit to data points D
Nd = 6;
D = exp(1i*(1:Nd)*2*pi/Nd);
D = D';
plot(D, 'k+')
% number of datums to fit
n = length(D);
% divide up path length
ss = linspace(0,Nb,n+1); ss = ss(1:end-1);
% initialise design matrix
X = zeros(n,Nb);

for i = 1:n
    
    % determind which span matrix is needed
    sig = floor(ss(i));
    % build rows of design matrix
    X(i,:) = (ss(i)-sig).^p * BG(:,:,sig+1);
    
end

% for regularisation
I = eye(size(X,2));
lmbda = 0;

% get control points
C = (X'*X+lmbda*I)\X'*D;

% evaluate fitted spline curve

Ns = 100;
ss = linspace(0,Nb, Ns+1);  ss = ss(1:end-1);

for i = 1:Ns
    
    % determind which span matrix is needed
    sig = floor(ss(i));
    s = (ss(i)-sig).^p;
%     s = [s zeros(1,d); zeros(1,d) s];
    f(:,i) = s * BG(:,:,sig+1) * C;
    
end

f(:,end+1) = f(:,1);
hold on
plot(f, '-r', 'lineWidth', 10)
plot(C, 'o', 'markerFaceColor', 'b')
plot(D, 'k+')




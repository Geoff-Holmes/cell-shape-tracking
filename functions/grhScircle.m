function s = grhScircle(k)

% return 0 to 2 pi in increments

if ~nargin
    k = 100;
end

s = linspace(0, 2*pi, k+1);
s = s(1:end-1);
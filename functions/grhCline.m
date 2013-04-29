function p = grhCline(x,y)

% draw lines between points represented by complex numbers in corresponding
% entries in x and y

assert(numel(x) == numel(y))

if size(x,2) == 1;
    x = conj(x');
    y = conj(y');
else
    x = x(1:numel(x));
    y = y(1:numel(y));
end

p = line(real([x; y]), imag([x; y]));
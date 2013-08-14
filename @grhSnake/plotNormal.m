function handle = plotNormal(obj, s)

switch nargin
    case 1
        n = obj.normal();
        c = obj.curve();
    case 2
        n = obj.normal(s);
        c = obj.curve(s);
end

handle = line([real(c-n)'; real(c+n)'], [imag(c-n)'; imag(c+n)']);
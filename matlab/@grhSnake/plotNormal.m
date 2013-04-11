function plotNormal(obj, s)

switch nargin
    case 1
        n = obj.normal();
        c = obj.curve();
    case 2
        n = obj.normal(s);
        c = obj.curve(s);
end

line([real(c)'; real(c+n)'], [imag(c)'; imag(c+n)'])
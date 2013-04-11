function plotNormal(obj, s, divs)

switch nargin
    case 1
        n = obj.normal();
        c = obj.curve();
    case 2
        n = obj.normal(s);
        c = obj.curve(s);
    case 3
        n = obj.normal(s, divs);
        c = obj.curve(s, divs);
end

line([real(c)'; real(c+n)'], [imag(c)'; imag(c+n)'])
function plotTangent(obj, s, divs)

switch nargin
    case 1
        t = obj.tangent();
        c = obj.curve();
    case 2
        t = obj.tangent(s);
    case 3
        t = obj.tangent(s, divs);
        c = obj.curve(s, divs);
end

line([real(c)'; real(c+t)'], [imag(c)'; imag(c+t)'])
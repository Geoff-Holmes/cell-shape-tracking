function plotTangent(obj, s, divs)

switch nargin
    case 1
        t = obj.tangent();
        c = obj.curve();
    case 2
        t = obj.tangent(s);
end

line([real(c)'; real(c+t)'], [imag(c)'; imag(c+t)'])
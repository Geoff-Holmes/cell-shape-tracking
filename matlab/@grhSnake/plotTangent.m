function plotTangent(obj, s)

switch nargin
    case 1
        t = obj.tangent();
        c = obj.curve();
    case 2
        t = obj.tangent(s);
        c = obj.curve(s);
end

line([real(c)'; real(c+t)'], [imag(c)'; imag(c+t)'])
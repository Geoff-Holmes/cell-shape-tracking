function result = grhGetOrientation(p)

% get orientation of shape defined by points p
% result is 1 if anticlockwise, 0 if clockwise

if min(size(p)) == 1
    p = [real(p) imag(p)];
end

[si,sj] = size(p);
if sj > si, p = p'; end

% test for repeat points
test = p(2:end,:) == repmat(p(1,:), si-1, 1);
test = sum(test,2);
if max(test) == 2
    ind = find(test==2);
    p = p(1:ind,:);
end
[si,sj] = size(p);

% ensure first two points are added at end
p = [p; p(1:2,:)];

for i = 1: si+1
    line(p(i:i+1,1), p(i:i+1,2));
end

% get edge vectors
vec = p(2:end,:)-p(1:end-1,:);
p = vec ./ repmat(sqrt(sum(vec.^2, 2)), 1, 2);

% get sine
qr = p(1:end-1,2).*p(2:end,1);
ps = p(1:end-1,1).*p(2:end,2);
r2as2 = sum(p(2:end,:).^2,2);
sintheta = (qr - ps)./ r2as2;

% get cosine
pr = p(1:end-1,1).*p(2:end,1);
qs = p(1:end-1,2).*p(2:end,2);
costheta = (pr + qs)./ r2as2;

% get true angle
theta = asin(sintheta);
theta = (costheta>=0).*theta + (costheta<0).*(sign(theta)*pi - theta);

totaltheta = sum(theta);
if totaltheta < 0
    result = 1;
else
    result = 0;
end

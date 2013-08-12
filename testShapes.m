addpath('../zFish_imageProcess/initialTests/')

T = 66
th = 1:12;
circ = exp(2*pi*1i*th/12);

star = repmat([1,3], 1,6).*circ;
% star(end+1) = star(1);
star = star*20;
star0 = star+50+520*1i;
star2 = star + 520 * (1+1i);
star4 = star2 + 400*1i;
sqr = [0 1 1+1i 1i]*40 + 700*(1+1i);
sqr1 = [0 1 1+1i 1i]*50 + 700 + 200 * 1i;

v = -1;

close all
for i = 1:T
    
% X{i} = makeCircleMask([1040 1040], [50 50]+5*i, 30, 'out');
m1 = makeCircleMask([1040 1040], 520+250*[cos(2*pi*i/T) sin(2*pi*i/T)], 30, 'out');

star1 = star0 + i*15 + 1i*200*sin(4*pi*i/T);
m2 = ~poly2mask(real(star1), imag(star1), 1040,1040);

star2 = star2 + 16*randn(1,2)*[1;1i];
% star2 = (star2-mean(star2)) * exp(1i*pi/12) + mean(star2);
m3 = ~poly2mask(real(star2), imag(star2), 1040,1040);

% star3 = repmat([3 3+2*sin(6*pi*i/T)], 1,6).*circ;
% star3 = 10*star3 +100*(1+1i);
% star3 = star3 + 5 * randn(1,2)*[1; 1i];
% m4 = ~poly2mask(real(star3), imag(star3), 1040,1040);
m4 = m3;

star4 = (star4-mean(star4)) *  exp(1i*pi/12) + mean(star4);
star4 = star4 + 5 * randn(1,2)*[1; 1i];
m5 = ~poly2mask(real(star4), imag(star4), 1040,1040);

sqr = sqr + 10*v;
v = v*exp(pi*1i*randn/6);
m6 = ~poly2mask(real(sqr), imag(sqr), 1040,1040);

sqr1 = (sqr1-mean(sqr1)) *  exp(1i*pi/12) + mean(sqr1);
sqr1 = sqr1 + 5 * randn(1,2)*[1; 1i];
m7 = ~poly2mask(real(sqr1), imag(sqr1), 1040,1040);

m8 = makeCircleMask([1040 1040], [900 900] + 5*randn(1,2), 30, 'out');

X{i} = ~(m1 & m2 & m3 & m4 & m5 & m6 & m7 & m8);
% X{i} = m1;

imshow(X{i})
pause(0.1)
end


save('testData', 'X')



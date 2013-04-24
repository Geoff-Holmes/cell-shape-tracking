clear all
close all

N = 200;
v = [ones(1,N/2) 2*ones(1,N/2)];

x = 0;

for i = 2:N
    x(i) = x(i-1) + v(i-1) + randn();
    y(i) = x(i) + randn();
end


A = [1 1; 0 1];
C = [1 0];
W = .01*[1/4 1/2; 1/2 1];
v = 1;

M = grhModel(A, C, W, v);

z{1} = [x(1); 0];
Q{1} = [1 0; 0 10];


for i = 2:N
    [z{i}, ~, Q{i}] = M.Filter(z{i-1}, Q{i-1}, y(i));
end

S.Bspline = grhBspline(2,2);

[z{:}]
plot(ans', 'b')
hold on
plot(y, 'r')

states = M.Smoother(z,Q);
[states{:}]
plot(ans', 'g')
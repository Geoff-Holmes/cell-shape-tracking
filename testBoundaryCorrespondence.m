% test boundary correspondence

close all
clear all

figure;
hold on;

% N = 30;
% c = exp(1i*grhScircle(N));
% B = grhBspline(N, 3);
% plot(c, 'r+')
% plot(c(1), 0, 'ro')
% 
% F = B.curve(c,0);
% plot(real(F), imag(F), 'go')
% F = B.curve(c,1);
% plot(real(F), imag(F), 'go')
% F = B.curve(c,2);
% plot(F, 'go')



x = exp(1i*wrev(grhScircle())) + 0*1i;
x = x + randn(1,length(x))*.1;

plot(x);
L{1} = 'raw data';
plot(real(x(1)), imag(x(1)), 'o');
L{end+1} = 'first data point';

B = grhBspline(20, 20);
[z, S] = B.dataFit(x);
plot(S, 'g');
L{end+1} = 'snake';

plot(S.curve(0), 'ro');
L{end+1} = 'start of snake';

plotNormal(S, 0)
L{end+1} = 'normal at 0';

plotCtrlPts(S)
L{end+1} = 'control points';

plot(S.ctrlPts(1), 'ko', 'markerSize', 10)
L{end+1} = 'control points for s=0';

plot(S.ctrlPts(2), 'mo', 'markerSize', 10)
L{end+1} = 'control points for s=1';

plot(S.ctrlPts(end), 'co', 'markerSize', 10)
L{end+1} = 'control points for s=L';

legend(L)
set(gcf, 'Position', [66 1 1615 971])
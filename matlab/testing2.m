close all
clear all

g = ginput(10);

B = grhBspline(5,4);

S = grhSnake(B.dataFit(g), B);

figure; hold on; plot(S)

C = B.getCmatrix(g);

recreate = C*S.ctrlPts

plot(recreate, 'r')
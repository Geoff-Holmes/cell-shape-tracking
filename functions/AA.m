function theta_C = AA(px1,px2)
C=dot(px1,px2)/(norm(px1)*norm(px2));
theta_C=acos(C);
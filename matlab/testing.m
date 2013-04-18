% clear all
Mg = working(6)

cell = Mg.cells{6};

close all
figure; hold on
 

for i = 1:(cell.lastSeen - cell.firstSeen)
    subplot(6,7,i); hold on
    if i>1, p0 = plot(cell, i-1); set(p0, 'color', 'm'), end
    axis([360 500 675 740])
    p1 = plot(Mg.frames{i}.bounds{cell.obsRefs(i)}, 'go');
    p2 = plot(cell, i);
%     plot(cell.snake(i).ctrlPts, 'b+')
    
%     p = plot(cell, i+1);
%     set(p, 'color', 'm')
%     cell.snake(i).plotNormal(0)
%     pause()
    p3 = plot(Mg.frames{i+1}.bounds{cell.obsRefs(i+1)}, 'r');%-cell.centroidShift(i+1), 'r');
    axis equal
%     pause()
%     delete(p1)
%     delete(p2)
%     delete(p3)
end
legend('last post', 'this obs', 'this post', 'next obs')
 
% figure;
% % subplot(1,2,1)
% plot(cell, 1);
% hold on
% plot(cell.snake(1).ctrlPts, 'g+')
% plot(Mg.frames{1}.bounds{cell.obsRefs(1)}, 'r')
% % subplot(1,2,2)
% hold on
% newBound = Mg.frames{2}.bounds{cell.obsRefs(2)}
% plot(newBound, 'k')
% [~,S] = Mg.Bspline.dataFit(newBound);
% plot(S)
% plot(S.ctrlPts, 'go')

% 
% close;
% figure; hold on
% plot(cell, 1)
% boundk1 = Mg.frames{2}.bounds{cell.obsRefs(2)}; %-cell.centroidShift(i+1);
% boundk0 = Mg.frames{1}.bounds{cell.obsRefs(1)};
% plot(boundk0, 'r');
% plot(boundk0(1), 'ko');
% plot(boundk1, 'g');
% plot(boundk1(1), 'ko');
% cell.snake(1).plotNormal(-1)

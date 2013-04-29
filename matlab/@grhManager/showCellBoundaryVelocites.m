function showCellBoundaryVelocites(obj, n)

nCell = obj.cells{n};

if ~nCell.smoothed
    display('Smoother not yet applied.  Showed filtered velocities'); 
end

for i = 1:length(nCell.states)-1

    plot(nCell.snake(i));
%     nCell.snake(i).plotNormal(0)
    C = nCell.Cmatrix{i};
    state = nCell.states{i};
    v = C * state(obj.Bspline.L+1:end);
    c = nCell.snake(i).curve(-length(v)); v = v(1:end-1);
    grhCline(c, c+v);
%     line(real(conj([c c+v]')), imag(conj([c c+v]')))
    hold on
    plot(nCell.snake(i+1), 'r'); 
    pause()
    hold off
end
function showBoundaryCorrespondence(obj, n)

nCell = obj.cells(n);

if ~nCell.smoothed
    display('Smoother not yet applied.  Showed filtered velocities'); 
end

for i = 1:length(nCell.states)-1

    iSnake = nCell.snake(i);
    plot(iSnake, 'g');
    hold on
    plotCtrlPts(iSnake, 'g');
    plot(iSnake.ctrlPts(1), 'go')
    plotNormal(nCell.snake(i), 0)
    plot(nCell.snake(i+1), 'r'); 
    plot(obj.frames{i+1}.bounds{nCell.obsRefs(i+1)}-nCell.centroidShift(i+1))
    plot(obj.frames{i+1}.bounds{nCell.obsRefs(i+1)}, ':')
    pause()
    hold off
end
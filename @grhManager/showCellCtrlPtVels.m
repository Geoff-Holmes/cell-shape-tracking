function showCellCtrlPtVels(obj, n)

nCell = obj.cells(n);

if ~nCell.smoothed
    display('Smoother not yet applied.  Showed filtered velocities'); 
end

for i = 1:length(nCell.states)-1
    
    % plot old snake
    plot(nCell.snake(i), 'g');
    hold on
    % plot old snake control points
    plotCtrlPts(nCell.snake(i), 'g');
    % plot first old control point
    plot(nCell.snake(i).ctrlPts(1), 'go');      
    % get ctrlPt velocitites from states
    state = nCell.states{i};
    v = state(obj.Bspline.L+1:end);
    % get corresponding snake boundary points
    c = nCell.snake(i).curve(-1); 
    % draw lines respresenting velocities
    grhCline(c, c+v);
    % plot next snake position and its ctrlPts, circling first
    plot(nCell.snake(i+1), 'r'); 
    plotCtrlPts(nCell.snake(i+1), 'r');
    plot(nCell.snake(i+1).ctrlPts(1), 'ro');
    pause()
    hold off
end
function plotSampleBoundaryVelocities(obj, cell, t0, step)

% plotSampleBoundaryVelocities(obj, cell, t0, step)

thisCell = obj.cells(cell);

times = t0:step:(thisCell.lastSeen-thisCell.firstSeen+1);
[rws, cls] = grhOptSubPlots(length(times));

n=1;
for t = times
    
    t
    subplot(rws,cls,n); n=n+1;
    % plot current cell outline
    plot(thisCell.snake(t));
    % set(p(j), 'color', cMap(cInd(j),:));
    hold on
    % calculate velocities from current states
    C = thisCell.Cmatrix{t};
    state = thisCell.states{t};
    v = C * state(obj.Bspline.L+1:end);
    lenV = length(v);
    ind = round(linspace(0, lenV, 40));
    v = v(ind(2:end));
    % get points on boundary where velocites have been calculated
    c = thisCell.snake(t).curve(-length(v));
    v = v(1:end-1);
    % plot velocity vectors
    grhCline(c, c+v);
    % plot cell position at next time frame if available
    if thisCell.lastSeen > t
        try
            plot(thisCell.snake(t+1), 'r'); 
        catch ex
            ex
        end
    end
    
end

    
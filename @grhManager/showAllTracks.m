function showAllTracks(obj)

figure; hold on;

flag = 1;

% distribute colors over colormap
cMap = colormap(jet);
cInd = floor(linspace(1, length(cMap), length(obj.cells)));

for j = 1:length(obj.cells)

    thisCell = obj.cells{j};

    if ~thisCell.smoothed && flag
        flag = 0;
        display('Smoother not yet applied.  Using filtered states'); 
    end
    
    % plot entire tracks for this cell
    for i = 1:length(thisCell.snake)
        p = plot(thisCell.snake(i));
        set(p, 'color', cMap(cInd(j),:));
    end
    
end


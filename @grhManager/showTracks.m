function showTracks(obj, tracks)

% display entire trajectory for cell/track IDs specified as list in tracks
% if no list specified show all tracks

% check whether a subset of tracks is specified
if nargin == 1
    tracks = 1:length(obj.cells);
end

figure; hold on;

% flag for reporting if smoothing has been applied
flag = 1;

% distribute colors over colormap one colour per track
cMap = colormap(jet);
cInd = floor(linspace(1, length(cMap), length(tracks)));

for j = 1:length(tracks)

    thisCell = obj.cells(tracks(j));

    if ~thisCell.smoothed && flag
        flag = 0;
        display('Smoother not yet applied.  Using filtered states'); 
    end
    
    % plot entire track for this cell
    for i = 1:length(thisCell.snake)
        p = plot(thisCell.snake(i));
        set(p, 'color', cMap(cInd(j),:));
    end
    
end


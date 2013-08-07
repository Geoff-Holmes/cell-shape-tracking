function animateTracks(obj, tracks)

% animate trajectory for cell/track IDs specified as list in tracks
% if no list specified show all tracks

% check whether a subset of tracks is specified
if nargin == 1
    tracks = 1:length(obj.cells);
end

figure;

% flag for reporting unsmoothed states
flag = 1;

% distribute colors over colormap one colour per track
cMap = colormap(jet);
cInd = floor(linspace(1, length(cMap), length(tracks)));

% get start and end time for these tracks
startFrame = min([obj.cells(tracks).firstSeen]);
endFrame   = max([obj.cells(tracks).lastSeen]);
    
% loop for repeating option
for s = 1:10
for t = startFrame:endFrame
    
    for j = 1:length(tracks)
        
        thisCell = obj.cells(tracks(j));
        
        if ~thisCell.smoothed && flag
            flag = 0;
            display('Smoother not yet applied.  Using filtered states'); 
        end
        
        if thisCell.firstSeen <= t && thisCell.lastSeen >= t
            p(j) = plot(thisCell, t-thisCell.firstSeen+1);
            set(p(j), 'color', cMap(cInd(j),:));
            axis([0 obj.DataXYlims(1) 0 obj.DataXYlims(2)]);
            c = 10*round(thisCell.centroid(t+1-thisCell.firstSeen)/10);
            txt(j) = text(real(c), imag(c)+50, num2str(tracks(j)));
            set(txt(j), 'color', cMap(cInd(j),:));
            hold on
        end
    end
    title(['Frame : ' num2str(t)])
    hold off
    % give option to pause between frames
    if s ==1 && t == 1
        button = questdlg('', 'Play mode', 'Continuous', ...
            'Pausing', 'Repeating', 'Continuous');
    end
    if strcmp(button, 'Pausing')
        pause()
    else
        pause(0.1)
    end
    if t == startFrame || t == endFrame
        pause(1)
    end
end
if ~strcmp(button, 'Repeating')
    break
end
end
 


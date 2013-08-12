function animateTracks(obj, tracks, option)

% animateTracks(obj, tracks, option)
%
% animate trajectory for cell/track IDs specified as list in tracks
% if no list specified show all tracks
% if option is true tracks in shape space will also be shown.

% check whether a subset of tracks is specified
if nargin == 1 || strcmp(tracks, 'all')
    tracks = 1:length(obj.cells);
end
if nargin < 3
    option = 0;
end

% get shape descriptor data if needed
if option && ~length(obj.shapeDescriptorLims)
    obj.storeShapeDescriptors;
end

f = figure;
% cleanup up routine to ensure figure closes
cleaner = onCleanup(@() close(f));

% flag for reporting unsmoothed states
flag = 1;

% distribute colors over colormap one colour per track
cMap = colormap(jet);
cInd = floor(linspace(1, length(cMap), length(tracks)));
% mix up colours so early tracks aren't all blue
cInd = cInd(randperm(length(cInd)));

% get start and end time for these tracks
startFrame = min([obj.cells(tracks).firstSeen]);
endFrame   = max([obj.cells(tracks).lastSeen]);

 
% loop for repeating option
for s = 1:10
for t = startFrame:endFrame
    
    if option
        subplot(1,2,2), hold off;
        title('Shape space')
        hold on;
        subplot(1,2,1);
    end
    hold off
    imshow(double(~obj.Data{t}) + .9*double(~~obj.Data{t}));
    title('Coordinate space')
    hold on
    
    for j = 1:length(tracks)
        
        if option, subplot(1,2,1); end
        thisCell = obj.cells(tracks(j));
        
        if ~thisCell.smoothed && flag
            flag = 0;
            display('Smoother not yet applied.  Using filtered states'); 
        end
        
        if thisCell.firstSeen <= t && thisCell.lastSeen >= t
            p(j) = plot(thisCell, t-thisCell.firstSeen+1);
            set(p(j), 'color', cMap(cInd(j),:));
            axis([0 obj.DataXYlims(1) 0 obj.DataXYlims(2)]);
            c = 10*round(thisCell.centroid(t-thisCell.firstSeen+1)/10);
            txt(j) = text(real(c), imag(c)+50, num2str(tracks(j)));
            set(txt(j), 'color', cMap(cInd(j),:));
            if option
                subplot(1,2,2)
                plotData = thisCell.snake(t-thisCell.firstSeen+1).shapeDescriptor;
%                 plot(plotData)
                try
                    q(j) = plot3(plotData(1), plotData(2), plotData(3), 'o');
                catch ex
                    q(j) = plot(plotData(1)+10, plotData(2)+10, 'o');
                end
                qxt(j) = text(plotData(1), plotData(2), num2str(tracks(j)));
                set(q(j), 'color', cMap(cInd(j),:));
                axis(obj.shapeDescriptorLims(1:end))
                axis square
            end
        end
    end
    suptitle(['Frame : ' num2str(t)])
%     hold off
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
 


function animateCrtlPtVelocities(obj, tracks, opt)

% animate boundary velocities for cell/track IDs specified as list in tracks
% if no list specified show all tracks

if obj.Bspline.L < 3
    display('WARNING: Bspline dimension less than 3 may cause problems with velocities');
end

% check whether a subset of tracks is specified
if nargin == 1
    tracks = 1:length(obj.cells);
end
if nargin < 3, opt=1; end

f = figure;
% cleanup up routine to ensure figure closes
cleaner = onCleanup(@() delete(f));

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
for t = startFrame:endFrame-1
    
    
%     imshow(double(~obj.Data{t}) + .9*double(~~obj.Data{t}));
%     hold on
    
    for j = 1:length(tracks)
        
        thisCell = obj.cells(tracks(j));
        
        if ~thisCell.smoothed && flag
            flag = 0;
            display('Smoother not yet applied.  Using filtered states'); 
        end
        
        if thisCell.firstSeen <= t && thisCell.lastSeen >= t
            
            % get correct time index for this cell
            tThis = t-thisCell.firstSeen+1;
%             % plot current cell outline
%             p(j) = plot(thisCell.snake(tThis));
%             set(p(j), 'color', cMap(cInd(j),:));
%             hold on
            if opt
                % plot control point
                cp = thisCell.snake(tThis).ctrlPts;
                plot(cp, '+')
                hold on
                plot(cp, 'o')
                grhCtext(cp);
                states = thisCell.states{tThis};
                grhCline(cp, ...
                    cp + states(obj.Bspline.L+1:obj.Bspline.L*2));
            end
%             % calculate velocities from current states
%             C = thisCell.Cmatrix{tThis};
%             state = thisCell.states{tThis};
%             v = C * state(obj.Bspline.L+1:end);
%             % get points on boundary where velocites have been calculated
%             c = thisCell.snake(tThis).curve(-length(v));
%             v = v(1:end-1);
%             % plot velocity vectors
%             grhCline(c, c+v);
            % plot cell position at next time frame if available
            if thisCell.lastSeen > t
                try
%                     plot(thisCell.snake(tThis+1), 'r'); 
                    if opt
                        % and also ctrlPts
                        plot(thisCell.snake(tThis+1).ctrlPts, 'r+')
                        plot(thisCell.snake(tThis+1).ctrlPts, 'ro')
                        grhCtext(thisCell.snake(tThis+1).ctrlPts);
                    end
                catch ex
                    ex;
                end
            end
            % plot cell position at prev time frame if available
            if thisCell.firstSeen < t
                try
                    cp1 = thisCell.snake(tThis-1).ctrlPts;
%                     plot(thisCell.snake(tThis-1), 'g'); 
                    if opt
                        % and also ctrlPts
                        plot(cp1, 'g+')
                        plot(cp1, 'go')
                        grhCtext(cp1);
                        states = thisCell.states{tThis-1};
                        grhCline(cp1, ...
                            cp1 + states(obj.Bspline.L+1:obj.Bspline.L*2));
                    end
                catch ex
                    ex;
                end
            end
            % label the cells
            c = 10*round(thisCell.centroid(tThis)/10);
            txt(j) = text(real(c), imag(c)+50, num2str(tracks(j)));
            set(txt(j), 'color', cMap(cInd(j),:));
        end
    end
    title(['Frame : ' num2str(t)])
    if nargin == 1
        axis([0 obj.DataXYlims(1) 0 obj.DataXYlims(2)]);
    end
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
 


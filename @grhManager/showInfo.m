function [enoughBoth, enoughSteps, enoughDist] = ...
    showInfo(obj, opts, minSteps, minDist, angleJumpThresh)

% [enoughBoth, enoughSteps, enoughDist] = ...
%   showInfo(obj, opts, minSteps, minDist, angleJumpThresh)
%
% Inputs:
%   opts is a string containing a comination of '1234'. Include:
%       1 to show number of steps and net distance by cell
%       2 to show jump length distributions
%       3 to show turn angle distributions
%       4 to show cell area distributions
%   minSteps and MinDist are thresholds above which a track is considere
%   'good' for further analysis
%
%   Outputs:
%       indices of tracks which are above the respective thresholds or both

if nargin < 2
    opts = '1234';
end
if nargin < 3
    minSteps = 10;
end
if nargin < 4
    minDist  = 30;
end
if nargin < 5
    angleJumpThresh = 5;
end

if ~isstruct(obj.info)
    obj.getTrackInfo(angleJumpThresh, minSteps, minDist)
end
    
N = length(obj.info);
iCells = 1:N;

if length(strfind(opts, '1')) || nargout
    
    Nsteps = [obj.info(:).Nsteps];
    totD   = [obj.info(:).totalDistance];
    
    figure;100
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1); hold on;
    b1 = bar(iCells, Nsteps);
    % draw threshold line
    l1 = grhCline(0+minSteps*1i, N+minSteps*1i);
    set(l1, 'color', 'k');
    set(gca, 'Xtick', iCells)
    xlim([0 N+1])
    xlabel('track number')
    ylabel('number of steps')
    title('number of observations by track')
    
    subplot(2,1,2); hold on;
    b2 = bar(iCells, totD);
    % draw threshold line
    l2 = grhCline(0+minDist*1i, N+minDist*1i);
    set(l2, 'color', 'k');
    set(gca, 'Xtick', iCells)
    xlim([0 N+1])
    xlabel('track number')
    ylabel('total distance migrated')
    title('total migration by track')
    
    % pick out best tracks
    test1 = Nsteps > minSteps;
    test2 = totD   > minDist;
    ind1  = test1 & test2;   % above both thresholds
    ind2  = test1 & ~test2;  % above step but not distance  
    ind3  = test2 & ~test1;  % above distance but not step
    b1bars = get(b1, 'children');
    b2bars = get(b2, 'children');
    set(b1bars, 'Cdata', 3*ind1 + 2*ind2)
    set(b2bars, 'Cdata', 3*ind1 + 1*ind3)

end

if nargout
    enoughBoth  = iCells(ind1);
    enoughSteps = iCells(test1);
    enoughDist  = iCells(test2);
end

% get a good subplot setup
[r, c] = grhOptSubPlots(N);

opt2 = length(strfind(opts, '2'));
opt3 = length(strfind(opts, '3'));
opt4 = length(strfind(opts, '4'));

if opt2
    f2 = figure('units','normalized','outerposition',[0 0 1 1]);
    suptitle('jump distributions')
end
if opt3
    f3 = figure('units','normalized','outerposition',[0 0 1 1]); 
    suptitle('turn angle distributions')
end
if opt4
    f4 = figure('units','normalized','outerposition',[0 0 1 1]); 
    suptitle('cell area distributions')
end

% bin edges for angle histogram
angleX = linspace(0, pi, 10);

for i = iCells
    
    if opt2
        % jumps
        set(0, 'currentfigure', f2)
        subplot(r, c, i)
        hist(obj.info(i).jumps)
        title(['cell ' num2str(i)])
    end
    if opt3
        % turn angles
        set(0, 'currentfigure', f3)
        subplot(r, c, i)
        n = histc(obj.info(i).angles, angleX);
        bar(angleX, n);
        xlim([0 pi])
        title(['cell ' num2str(i)])
    end
    if opt4
        % area
        figure(f4)
        subplot(r, c, i)
        hist(obj.info(i).areas)
        title(['cell ' num2str(i)])
    end
    
end
    




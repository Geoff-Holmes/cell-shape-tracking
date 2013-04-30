function showInfo(obj, opts)

if ~isstruct(obj.info)
    obj.getTrackInfo()
end

if nargin == 1
    opts = '1234';
end

N = length(obj.info);
iCells = 1:N;

if length(strfind(opts, '1'))
    figure;
    subplot(2,1,1)
    bar(iCells, [obj.info(:).Nsteps])
    set(gca, 'Xtick', iCells)
    title('number of observations by track')
    subplot(2,1,2)
    bar(iCells, [obj.info(:).netDistance])
    set(gca, 'Xtick', iCells)
    title('net migration by track')
end

% get a good subplot setup
[r, c] = grhOptSubPlots(N);

opt2 = length(strfind(opts, '2'));
opt3 = length(strfind(opts, '3'));
opt4 = length(strfind(opts, '4'));

if opt2
    f2 = figure(); suptitle('jump distributions')
end
if opt3
    f3 = figure(); suptitle('turn angle distributions')
end
if opt4
    f4 = figure(); suptitle('cell area distributions')
end

% bin edges for angle histogram
angleX = linspace(0, pi, 10);

for i = iCells
    
    if opt2
        % jumps
        figure(f2)
        subplot(r, c, i)
        hist(obj.info(i).jumps)
        title(['cell ' num2str(i)])
    end
    if opt3
        % turn angles
        figure(f3)
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
    




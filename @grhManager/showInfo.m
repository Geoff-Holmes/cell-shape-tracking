function showInfo(obj)

if ~isstruct(obj.info)
    obj.getTrackInfo()
end

N = length(obj.info);
iCells = 1:N;

figure;
subplot(2,1,1)
bar(iCells, [obj.info(:).Nsteps])
set(gca, 'Xtick', iCells)
title('number of observations by track')

subplot(2,1,2)
bar(iCells, [obj.info(:).netDistance])
set(gca, 'Xtick', iCells)
title('net migration by track')

% get a good subplot setup
[r, c] = grhOptSubPlots(N);

f2 = figure(); suptitle('jump distributions')
f3 = figure(); suptitle('turn angle distributions')
f4 = figure(); suptitle('cell area distributions')

% bin edges for angle histogram
angleX = linspace(0, pi, 10);

for i = iCells
    
    % jumps
    figure(f2)
    subplot(r, c, i)
    hist(obj.info(i).jumps)
    title(['cell ' num2str(i)])
    
    % turn angles
    figure(f3)
    subplot(r, c, i)
    n = histc(obj.info(i).angles, angleX);
    bar(angleX, n);
    xlim([0 pi])
    title(['cell ' num2str(i)])
    
    % area
    figure(f4)
    subplot(r, c, i)
    hist(obj.info(i).areas)
    title(['cell ' num2str(i)])
    
end
    




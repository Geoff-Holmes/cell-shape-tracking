function playData(obj)

% playData(obj, speed)
%
% play through the data with animation control

f = figure;

warning('off', 'Images:initSize:adjustingMag')

% cleanup up routine to ensure figure closes
cleaner = onCleanup(@() delete(f));

t = 1;            % current / starting frame frame
T = obj.DataL;    % final frame / data length
abort = 0;        % stopping flag
tic;              % i.e. initiate timer

I = imshow(obj.Data{t});

while ~abort
    
    % control
    if t == 1, xlabel('Animation Control Frame'); end
    run functions/grhAnimationControl
    
    set(I, 'CData', obj.Data{t});
    title(['Frame : ' num2str(t)])
    pause(0.001) % big plotting time requires minimum pause
%     set(gcf, 'Position', [420 190 870 640])
    

    
end
    
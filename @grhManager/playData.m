function playData(obj, framePause)

% playData(obj, speed)
%
% play through the data
% framepause specifies time in seconds to pause between frames
% default is 0.2, if set to 0 pause until user button press

if nargin == 1
    framePause = 0.2;
end

f = figure;

warning('off', 'Images:initSize:adjustingMag')

% cleanup up routine to ensure figure closes
cleaner = onCleanup(@() delete(f));

for t = 1:obj.DataL
    
    imshow(obj.Data{t})
    title(['Frame : ' num2str(t)])
    
    if framePause
        pause(framePause)
    else
        pause()
    end
    
end
    
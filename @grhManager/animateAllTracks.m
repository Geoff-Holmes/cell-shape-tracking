function animateAllTracks(obj)

flag = 1;

for t = 1:length(obj.frames)
    
    for j = 1:length(obj.cells)
        
        thisCell = obj.cells(j);
        
        if ~thisCell.smoothed && flag
            flag = 0;
            display('Smoother not yet applied.  Using filtered states'); 
        end
        if thisCell.firstSeen <= t && thisCell.lastSeen >= t
            p(j) = plot(thisCell, t-thisCell.firstSeen+1);
            axis([0 obj.DataXYlims(1) 0 obj.DataXYlims(2)]);
            hold on
        end
    end
    pause(0.01)
    hold off
%     delete(p)
end
% 


function animateTrack(obj, n)

figure(gcf); clf;

if nargin == 2
    
    C = n;
else
    C = 1:length(obj.cells)
end

for i = C
    
    thisCell = obj.cells(i);
    hold on;

    if ~thisCell.smoothed
        display('Smoother not yet applied.  Using filtered states'); 
    end    

    for j = 1:thisCell.lastSeen - thisCell.firstSeen
        

        
        p1 = plot(thisCell, j);

        hold on 
        try
        p2 = plot(obj.frames{j+thisCell.firstSeen -1}.bounds{thisCell.obsRefs(j)}, 'r');
        catch ex
            ex
        end
        c = 10*round(thisCell.centroid(1)/10);
        text(real(c), imag(c)+50, num2str(i))
        title(['Cell ' num2str(i)]); 
        axis([0 obj.DataXYlims(1) 0 obj.DataXYlims(2)]);
        pause(0.05)
        hold off
    end
    
end

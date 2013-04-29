function showTrack(obj, n)

figure(gcf); clf;

if obj.cells{1}.smoothed
    display('Smoother not yet applied.  Using filtered states'); 
end

if nargin == 2
    
    C1 = n;
    C2 = n;
else
    C1 = 1;
    C2 = length(obj.cells)
end

for i = C1:C2
    
    thisCell = obj.cells{i};
     hold on;
    
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
        title(['Cell ' num2str(i)]); axis([200 1100 550 950]);
        pause(0.05)
        hold off
    end
    
end
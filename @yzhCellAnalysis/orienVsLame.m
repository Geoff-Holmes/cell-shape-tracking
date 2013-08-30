function [] = orienVsLame(obj,n)

%   obj.orienVsLame(n) output the polar histogram 
%   obj    = Ay from yzhCellAnalysis
%   n      the number of cell or iCell
%   applied after identifying cell front(lameLocation)
%% --------------------------------------------------------------------  %%
C = n;
% ------------ figure define --------------------  %
scrsz = get(0,'ScreenSize');
f2=figure('Position',[1 1 scrsz(3)/1.7 scrsz(4)]);
colordef(f2,'white');
set(gcf,'Color',[1 1 1]);
set(gca,'FontSize',20);
axis equal 
c2 = 0;
for iCell = C
    thisCell = obj.cellTracks.cells(iCell);
    orien = obj.orientation{iCell};
    angleP = obj.anglePP{iCell};
    Mem_lame = obj.lames.lameLoc{iCell};
    
    cla;
    fprintf('----fig.(l)-----\n red -- front\n light blue -- side\n yellow -- rear\n blue histogram -- the no. of lamellipodia')
    radius = 0.1;
    
    % ----- count the point with lamellipodia ------- %
    for iFrame = 1:(thisCell.lastSeen - thisCell.firstSeen)
        for k = 1:length(orien{iFrame})
            if (Mem_lame{iFrame}(k) == 1)
                c2 = c2+1;
                angAll(c2) = angleP{iFrame}(k)/180*pi;
            end
        end
    end
   
    for k = 1:(c2+1)
        angAll(c2+k) = 2*pi-angAll(k)-0.001;
    end
    % ----- draw the circle
    h = polar([0,2*pi],[0, radius]);
    delete(h);
    hold on
    h1 = secdraw(0,40*pi/180,radius,1);
    h2 = secdraw(40*pi/180,95*pi/180,radius,2); 
    h3 = secdraw(135*pi/180,45*pi/180,radius,3);
    [h r] = rose(angAll(1,:));
    r = r./sum(r)*2;
    polar(h,r);
    grid on;
    
    h = legend('Front','Side','Rear','The no. of Lame','Location','NorthEast');
    set(h,'FontSize',18,'FontWeight','bold');
     
    secdraw(320*pi/180,40*pi/180,radius,1);
    secdraw(225*pi/180,95*pi/180,radius,2); 
    secdraw(180*pi/180,45*pi/180,radius,3);
     
    hline = findobj(gca,'Type','line');
    set(hline,'LineWidth',2,'color','b');     
    drawnow;   
end

   
 
        
%         
   
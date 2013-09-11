function [theta,thetaEach] = orienVsLame(obj,n,opts)

%   obj.orienVsLame(n) output the polar histogram 
%   obj    = Ay from yzhCellAnalysis
%   n      the number of cell or iCell
%   opts  = '1'; give an overview of lamellipodia distribution;
%   opts  = '2'; give the polar historgram of each cell;
%   opts  = '3'; give the curve review of each cell;
%   applied after identifying cell front(lameLocation)
%% --------------------------------------------------------------------  %%
if nargin < 3
    opts = '123'
end
C = n;
% ------------ figure define --------------------  %
scrsz = get(0,'ScreenSize');
f1=figure('Position',[1 1 scrsz(3)/1.72 scrsz(4)]);
colordef(f1,'white');
set(gcf,'Color',[1 1 1]);
set(gca,'FontSize',20);
axis equal 
c2 = 0;
fprintf('----fig.(l)-----\n red -- front\n light blue -- side\n yellow -- rear\n blue histogram -- the no. of lamellipodia')

if length(strfind(opts,'1')) || nargout
    for iCell = C
        c3 = 0;
        thisCell = obj.cellTracks.cells(iCell);
        orien = obj.orientation{iCell};
        angleP = obj.anglePP{iCell};
        Mem_lame = obj.lames.lameLoc{iCell};
        radius = 0.1;

        % ----- count the point with lamellipodia ------- %
            cla;
            hold on
        for iFrame = 1:(thisCell.lastSeen - thisCell.firstSeen)
            for k = 1:length(orien{iFrame})
                if (Mem_lame{iFrame}(k) == 1)
                    c2 = c2+1;
                    c3 = c3+1;
                    angAll(c2) = angleP{iFrame}(k)/180*pi;
                    angEach{iCell}(c3) = angleP{iFrame}(k)/180*pi;                   
                end
            end
        end
             
        for k = 1:(c2+1)
            angAll(c2+k) = 2*pi-angAll(k)-0.001;
        end
        
        angE{iCell} = angEach{iCell};
        for k = 1:(c3+1)
            angE{iCell}(c3+k) =  2*pi-angE{iCell}(k)-0.001;
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
        p = polar(h,r);
        set(p,'linewidth',2);
        grid on;

        legend('Front','Side','Rear','The no. of Lame','Location','NorthEast','Orientation','Vertical');
    %     set(h,'FontSize',18,'FontWeight','bold');

        secdraw(320*pi/180,40*pi/180,radius,1);
        secdraw(225*pi/180,95*pi/180,radius,2); 
        secdraw(180*pi/180,45*pi/180,radius,3);

        hline = findobj(gca,'opts','line');
        set(hline,'LineWidth',2,'color','b');     
        drawnow; 
    end
    
     % ---- curve ------
        scrsz = get(0,'ScreenSize');
        f11=figure('Position',[1 1 scrsz(3)/1.72 scrsz(4)]);
        colordef(f11,'white');
        set(gcf,'Color',[1 1 1]);
        set(gca,'FontSize',20);
       cla;
       hold on
       grid on;
       yAll = [];
       xAll = [];
       [yAll,xAll] = ksdensity(angAll(1,1:(length(angAll)-1)/2));
       plot(xAll,yAll,'b','LineWidth',2); % curve       yt = []; xt = [];
       for ic = C(1):iCell
           if ~isempty(angEach{ic})
            [yt(ic,:),xt] = ksdensity(angEach{ic}(:)); 
           end
       end
       s = std(yt,0,1)
       fill([xt,fliplr(xt)],[yAll+s,fliplr(yAll-s)],'b','FaceAlpha',0.3,'linestyle','none');
       
       % ----- title & label ------
       axis([0 3.14 0 0.7]);
       xlabel('Cell Orientation')
       ylabel('Distribution of lamellipodia')
       plot([2.355,2.355],[0,0.7],'m-');
       plot([0.7,0.7],[0,0.7],'m-')
       text(0.2,0.1,'Front','HorizontalAlignment','left','FontSize',18);
       text(1.4,0.1,'Side','HorizontalAlignment','left','FontSize',18);
       text(2.7,0.1,'Rear','HorizontalAlignment','left','FontSize',18);
       
end




opt2 = length(strfind(opts,'2'));
opt3 = length(strfind(opts,'3'));

if opt2
    f2 = figure('units','normalized','outerposition',[0 0 1 1]);
    suptitle('polar histogram for each cell')
end
if opt3
    f3 = figure('units','normalized','outerposition',[0 0 1 1]); 
    suptitle('curve for each cell');
end
save yt
[rol,col] = grhOptSubPlots(length(C))
ic = 0;
for i = C
    ic = ic + 1
    if opt2 
        %   polar hist
        radius = 0.1;
        set(0,'currentfigure',f2)
        subplot(rol,col,ic)
        hold on
        h = polar([0,2*pi],[0, radius]);
        delete(h);
        hold on
        h1 = secdraw(0,40*pi/180,radius,1);
        h2 = secdraw(40*pi/180,95*pi/180,radius,2); 
        h3 = secdraw(135*pi/180,45*pi/180,radius,3);
        [h r] = rose(angE{i}(:));
        r = r./sum(r)*2;
        p = polar(h,r);
        set(p,'linewidth',2);
        grid on;

        secdraw(320*pi/180,40*pi/180,radius,1);
        secdraw(225*pi/180,95*pi/180,radius,2); 
        secdraw(180*pi/180,45*pi/180,radius,3);

        hline = findobj(gca,'opts','line');
        set(hline,'LineWidth',2,'color','b');  
        axis equal;
        drawnow; 
        title(['cell',num2str(i)]);
    end
    
    if opt3
    %   curve 
    set(0, 'currentfigure', f3)
    subplot(rol,col,ic)
       hold on
       grid on;
       yEach = [];
       xEach = [];
       [yEach,xEach] = ksdensity(angEach{i}(1,:));
       plot(xEach,yEach,'b','LineWidth',1); % curve       yt = []; xt = [];
       % ----- title & label ------
       axis([0 3.14 0 1]);
       xlabel('Cell Orientation')
       ylabel('Distribution of lamellipodia')
       plot([2.355,2.355],[0,1],'m-');
       plot([0.7,0.7],[0,1],'m-')
       text(0.2,0.1,'Front','HorizontalAlignment','left');
       text(1.4,0.1,'Side','HorizontalAlignment','left');
       text(2.7,0.1,'Rear','HorizontalAlignment','left');
       drawnow; 
       title(['cell',num2str(i)]);
    end
end

theta = angAll;
thetaEach = angEach;

   
 
        
%         
   
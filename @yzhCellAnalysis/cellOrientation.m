function [NP] = cellOrientation(obj,n,plt)
%   NP = obj.cellOrientation(n,plt)
%   n           is the number of cell needed to analysis
%   obj         is yzhCellAnalysis
%   plt = 2     draw the resutl by 3D which is really really slow,if not
%   necessary, please do not use this one.
%   plt = 1     draw the result by 2D
%  
if nargin == 3
    C = n;
    plt = 1;% dont draw the figure
elseif nargin == 2
    C = n;
    plt = 0; % draw the figure
else
    disp('Not enough input !!!');
end

if isempty(obj.lames) 
    disp('There is no information about lamellipodia !')
    return ;
end

%% angle between point on the contour and the velocity of the same point
for iCell = C
    thisCell = obj.cellTracks.cells(iCell);   
    for iFrame = 1:(thisCell.lastSeen - thisCell.firstSeen)
        
        d = thisCell.obsRefs(iFrame);
        centroid = thisCell.centroid(iFrame);
        pCell = thisCell.Bspline.curve(thisCell.states{iFrame}(1:thisCell.Bspline.L));
        vCell = thisCell.Bspline.curve(thisCell.states{iFrame}(thisCell.Bspline.L+1:end));
        ppCell = pCell - centroid;
        for k = 1:length(pCell)
            anglePV(k)= AA([real(ppCell(k)),imag(ppCell(k))],[real(vCell(k)),imag(vCell(k))]);
        end
        In = [];
        [Reff,In] = min(anglePV);
        for k = 1:length(pCell)
            anglePP(k) = real(AA([real(ppCell(k)),imag(ppCell(k))],[real(ppCell(In(1))),imag(ppCell(In(1)))])*180/pi);
        end   
        tempAng{iFrame} = anglePP;
%         anglePPCom = sort(anglePP);
        
        indf = find(anglePP <= 40);
        inds = find(anglePP > 40 & anglePP <= 135);
        indr = find(anglePP > 135);
        
        NP{iFrame}(indf) = 1;
        cellFront{iCell}{iFrame}(1:length(indf)) = pCell(indf);
        
        NP{iFrame}(inds) = 0;
        cellSide{iCell}{iFrame}(1:length(inds)) = pCell(inds);
        
        NP{iFrame}(indr) = -1;
        cellRear{iCell}{iFrame}(1:length(indr)) = pCell(indr);
        clear indf inds indr ;
    end
    obj.orientation{iCell} = NP;
    obj.anglePP{iCell} = tempAng;
    clear thisCell
end
      
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          plot results   3D                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt == 2
    scrsz = get(0,'ScreenSize');
    h1 = figure;
    colordef(h1,'white');
    set(gcf,'Units','normalized');
    set(gcf,'Position',[0 0 0.8 1]);
    set(gca,'FontSize',20);
    hold on
    set(gcf,'Color',[1 1 1]);
    plotCols = colormap;
    grid on;
    for iCell = C
        thisCell = obj.cellTracks.cells(iCell);
        for iFrame = 1:(thisCell.lastSeen - thisCell.firstSeen)   
            disp(['Cells: ', num2str(iCell),' Frame: ',num2str(iFrame)]);
            hold on;
            h1 = plot3(real(cellFront{iCell}{iFrame}),imag(cellFront{iCell}{iFrame}),iFrame*ones(length(cellFront{iCell}{iFrame})),'r+','linewidth',2); 
            h2 = plot3(real(cellRear{iCell}{iFrame}),imag(cellRear{iCell}{iFrame}),iFrame*ones(length(cellRear{iCell}{iFrame})),'y+','linewidth',2); 
            h3 = plot3(real(cellSide{iCell}{iFrame}),imag(cellSide{iCell}{iFrame}),iFrame*ones(length(cellSide{iCell}{iFrame})),'b+','linewidth',2);
            centroid = thisCell.centroid(iFrame);

            h4 = plot3(real(centroid),imag(centroid),iFrame,'k.','linewidth',2);
            pCell = thisCell.Bspline.curve(thisCell.states{iFrame}(1:thisCell.Bspline.L));

            plot3(real(pCell),imag(pCell),iFrame*ones(length(pCell)),'-','color',plotCols(iFrame,:,:),'linewidth',1);
            if iFrame >1    
                cp = thisCell.centroid(iFrame-1);
                h5 = quiver3(real(cp),imag(cp),iFrame-1,real(centroid-cp),imag(centroid-cp),1);
            end
                drawnow;     
        end

      view(30,15)
      h = legend([h1(1),h2(1),h3(1),h4(1),h5(1)],'Front','Rear','Side','Centroid','Migrational direction','Location','NorthEast');
      set(h,'FontSize',16,'FontWeight','bold');
      xlabel('x position','fontsize',25);    ylabel('y position','fontsize',25); 
      zlabel('Frames');
    %   m = title('Orientation identification','FontSize',20,'FontWeight','bold');    
      hold off
    end
    
    if plt == 1
        scrsz = get(0,'ScreenSize');
        h1 = figure;
        colordef(h1,'white');
        set(gcf,'Units','normalized');
        set(gcf,'Position',[0 0 0.8 1]);
        set(gca,'FontSize',20);
        hold on
        set(gcf,'Color',[1 1 1]);
        plotCols = colormap;
        grid on;
        for iCell = C
            thisCell = obj.cellTracks.cells(iCell);
            for iFrame = 1:(thisCell.lastSeen - thisCell.firstSeen)   
                disp(['Cells: ', num2str(iCell),'Frame: ',num2str(iFrame)]);
                hold on;
                h1 = plot(cellFront{iCell}{iFrame},'r+','linewidth',2); 
                h2 = plot(cellRear{iCell}{iFrame},'y+','linewidth',2); 
                h3 = plot(cellSide{iCell}{iFrame},'b+','linewidth',2);
                centroid = thisCell.centroid(iFrame);

                h4 = plot(centroid,'k.','linewidth',2);
                pCell = thisCell.Bspline.curve(thisCell.states{iFrame}(1:thisCell.Bspline.L));

                plot(pCell,'-','color',plotCols(iFrame,:,:),'linewidth',1);
                if iFrame >1    
                    cp = thisCell.centroid(iFrame-1);
                    h5 = quiver(real(cp),imag(cp),real(centroid-cp),imag(centroid-cp));

                end
                     pause;     
            end

          h = legend([h1(1),h2(1),h3(1),h4(1),h5(1)],'Front','Rear','Side','Centroid','Migrational direction','Location','NorthEast');
          set(h,'FontSize',16,'FontWeight','bold');
          xlabel('x position','fontsize',25);    ylabel('y position','fontsize',25); 
          m = title('Orientation identification','FontSize',20,'FontWeight','bold');    
          hold off
        end
    end
end










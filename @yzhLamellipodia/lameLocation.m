function [lameLocation]=lameLocation(obj,n,plt)
% This programme used to connect the lamellipodia to the tracked cells
% Find the range of lamellipodia over the boundary              %
if nargin == 3
    C = n;
elseif nargin ==2
    C =n;
    plt = 0;
end
rr = 0;
for iCell = C
    thisCell = obj.tracks.cells(iCell);
    for iFrame = 1:thisCell.lastSeen - thisCell.firstSeen
        d = thisCell.obsRefs(iFrame);
        normalV = thisCell.Bspline.normal(thisCell.states{iFrame}(1:thisCell.Bspline.L));
        pCell = thisCell.Bspline.curve(thisCell.states{iFrame}(1:thisCell.Bspline.L));
        lameLabel = zeros(size(pCell));
        if obj.NLame{iFrame}{d} ~= 0
            for iLame = 1:obj.NLame{iFrame}{d}
                pLame = obj.CLbounds{iFrame}{d}{iLame};
                
                for m = 1:length(pLame)%points on lamellipodia
                    for n = 1:length(pCell);
                        
                        if lameLabel(n)==1
                            continue;                            
                        elseif (sqrt((real(pCell(n))-real(pLame(m)))^2+(imag(pCell(n))-imag(pLame(m)))^2 )< 15)
                               x = [real(pCell(n)), real(pLame(m))];
                               y = [imag(pCell(n)), imag(pLame(m))];
                           if (abs(((y(2)-y(1))./(x(2)-x(1)))-(imag(normalV(n))/real(normalV(n)))) < 0.1 |abs(((x(2)-x(1))./(y(2)-y(1)))-(real(normalV(n))/imag(normalV(n)))) < 0.1)
                               lameLabel(n)=1; 
                           end
                           
                         end
                    end
                end
            end
        end
      lameLocation{iCell}{iFrame} = lameLabel; 
    end
end
save ll 
%                                
if plt ~= 0

    NPix = 1082;
    h1 = figure;
    colordef(h1,'white');
    set(gcf,'Color',[1 1 1]);
    hold on;
    plotScale = [0 NPix -600 0];
    set(gcf,'Units','normalized');
    set(gcf,'Position',[0 0 0.8 1]);
    set(gca,'FontSize',20);
    colr = colormap;
    
    for iCell = C
        c = mod(iCell*10,64);
        thisCell = obj.tracks.cells(iCell);
        for iFrame = 1:thisCell.lastSeen - thisCell.firstSeen
            cla;
            d = thisCell.obsRefs(iFrame);
            pCell = thisCell.Bspline.curve(thisCell.states{iFrame}(1:thisCell.Bspline.L));
            plot(pCell,'b');
            normal = thisCell.Bspline.normal(thisCell.states{iFrame}(1:thisCell.Bspline.L));
            quiver(real(pCell),imag(pCell),-real(normal),-imag(normal));
            
            hold on
%             idx = find(lameLocation{iCell}{iFrame} == 1)
            plot(pCell(idx),'r*');
            for iLame = 1:obj.NLame{iFrame}{d}
                plot(obj.CLbounds{iFrame}{d}{iLame},'k');
            end
            pause;
        end
    end
end

            
    
    
%                     
%             
%         
% 
%     
%    
%         
%         
%         
%         
%         
%         
%         
%         Mem_intersection=cell(size(longtrackCell,2),10);
%     Mem_lema = cell(size(longtrackCell,2),10);
%     for i =  2:NFrames   
%         for j = 1:size(longtrackCell,2) %cell
%             Mem_intersection{j,i}=cell(size(pCell{j,i},1),1);    
%             hold on
%             %----cell boundary------%
%             h1 = plot3(pCell{longtrackCell(j),i}(:,1),pCell{longtrackCell(j),i}(:,2),i*ones(length(pCell{longtrackCell(j),i}(:,1)),1),'-','color',pltCol(i,:,:),'linewidth',2);
%             plot3(centrX{j,i},centrY{j,i},i,'b.','LineWidth',1);
%             if i > 2
%                 %--------migration direction-----%
%             h2 = quiver3(centrX{j,i-1},centrY{j,i-1},i-1,centrX{j,i}-centrX{j,i-1},centrY{j,i}-centrY{j,i-1},1);
%             end
%         drawnow;    
%             % ...draw the lema...
%             d = lameIndex(longtrackCell(j),i);        
%             for k = 1:NL{i}{d}
%                 plot3(boundaries_L{i}{d}{k}(:,2),-boundaries_L{i}{d}{k}(:,1),i*ones(length(boundaries_L{i}{d}{k}(:,1))),'color',pltCol(i,:,:),'linewidth',1);     
%             end 
%             
%             Mem_lema{j,i} = zeros(size(pCell{j,i},1),1);
%             %... ... ... ... ...
%             for k=1:NL{i}{d}
%                for m = 1:size(boundaries_L{i}{d}{k}(:,2),1) 
%                    normalV = nVec(pCell{longtrackCell(j),i}(:,1),pCell{longtrackCell(j),i}(:,2));
%                    for n = 1:size(pCell{j,i},1) %point on the cell
%                        if(((pCell{longtrackCell(j),i}(n,1)- boundaries_L{i}{d}{k}(m,2))^2+(pCell{longtrackCell(j),i}(n,2)+boundaries_L{i}{d}{k}(m,1))^2)<200)
%                            x = [pCell{longtrackCell(j),i}(n,1),boundaries_L{i}{d}{k}(m,2)];
%                            y = [pCell{longtrackCell(j),i}(n,2),-boundaries_L{i}{d}{k}(m,1)];
%                            if (abs((y(2)-y(1)).\(x(2)-x(1))-normalV(n,1)) < 0.2 | abs((x(2)-x(1)).\(y(2)-y(1))-normalV(n,2)) < 0.2)
%                                Mem_intersection{j,i}{m,k}{n} = 1;
%                                Mem_lema{j,i}(n,1)=1;
%                                if Mem_lema{j,i}(n,1)==1;
%                                   h3 = plot3(pCell{longtrackCell(j),i}(n,1),pCell{longtrackCell(j),i}(n,2),i*ones(length(pCell{longtrackCell(j),i}(n,2))),'k+','linewidth',4);
%                                end
%                            end
%                        end
%                    end
%                end
%            end
%         end
%     drawnow;
%     end
% %     h = legend([h1(1),h2(1),h3(1)],'Cell boundary with lamellipodia','Migrational direction','Detected lamellipodia','Location','NorthEast');
% %     set(h,'FontSize',25,'FontWeight','bold');
%     xlabel('x position','fontsize',25);    ylabel('y position','fontsize',25);
%     zlabel('Frames','fontsize',25);
% %     m = title('The distribution of lamellipodia for a certain cell','FontSize',20,'FontWeight','bold');   
%     save matSave/lamellipodia NFrames cellIndex boundaries_L NL lameIndex Mem_lema Mem_intersection    
% end
% 


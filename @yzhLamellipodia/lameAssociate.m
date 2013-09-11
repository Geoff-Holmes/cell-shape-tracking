function [] = lameAssociate(obj,plt)

% The function used to extract the cell and the associated lemollipodia
% obj from yzhLamellipodia.m
% plt = 1 plot the figure
% plt = 0 no plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
    plt = 0;
end
%% center
NFrames = obj.tracks.DataL;
for iFrame = 1:NFrames
    for iCell = 1:obj.tracks.frames(iFrame).cellCount
        Label_lame{iFrame}(iCell)=0;          % initialization
        Center_Cell{iFrame}{iCell} = obj.tracks.frames(iFrame).centroids(iCell);
    end
    for iC = 1:length(obj.refCellBounds{iFrame}) 
        Center_C{iFrame}{iC} = mean(obj.refCellBounds{iFrame}{iC}); %raw info from image
    end
end

% the closest lamellipodia and cell
for iFrame = 1:NFrames
    % the loop of 
    
        for iCell = 1:obj.tracks.frames(iFrame).cellCount % ----- cell
            
            for iC = 1:length(obj.refCellBounds{iFrame})
                Distance{iCell}(iC) = (real(Center_C{iFrame}{iC}-Center_Cell{iFrame}{iCell})^2 ...
                       +imag(Center_C{iFrame}{iC}-Center_Cell{iFrame}{iCell})^2);    
            end
            
            if Label_lame{iFrame}(iCell) == 0;  
                d = 0; MinD = 0;
                [MinD,d] = min(Distance{iCell});
                Label_lame{iFrame}(iCell) = d ;
            end
        
        end
        clear Distance
        
end

save aa
%% sort out
for iFrame = 1:NFrames
    CLbounds{iFrame}={};
    for iCell = 1:obj.tracks.frames(iFrame).cellCount
         NLame{iFrame}{iCell} = 0;
            CLbounds{iFrame}{iCell} = obj.lameBounds{iFrame}{Label_lame{iFrame}(iCell)};%(:,2) is x, -(:,1) is y
            NLame{iFrame}{iCell} = length(CLbounds{iFrame}{iCell}); %the no. of lemollipodia for each cell
    end
end

 obj.NLame = NLame;
 obj.CLbounds = CLbounds;
if (plt == 1)
    figure;
    set(gcf,'color',[1,1,1]);
    colr = colormap;
   for iFrame = 1:NFrames
       disp(['Frames : ',num2str(iFrame)]);
       cla;
       hold on;
       for iCell = 1:obj.tracks.frames(iFrame).cellCount
           c = mod(iCell*10,64);
           plot(obj.tracks.frames(iFrame).bounds{iCell},'color',colr(c,:,:));
           for iLame = 1:NLame{iFrame}{iCell}
               plot(CLbounds{iFrame}{iCell}{iLame},'color',colr(c,:,:));
           end
           pause
       end
       pause;
   end
end









                       
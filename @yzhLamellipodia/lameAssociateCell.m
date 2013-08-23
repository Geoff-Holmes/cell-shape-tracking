function [] = lameAssociateCell(obj,plt)

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
        Center_Cell{iFrame}{iCell} = obj.tracks.frames(iFrame).centroids(iCell);
    end
    for iLame = 1:length(obj.lameBounds{iFrame}) 
         Label_lame{iFrame}{iLame}=0; % initialization
        Center_lame{iFrame}{iLame} = mean(obj.lameBounds{iFrame}{iLame});
    end
end

% the closest lamellipodia and cell
for iFrame = 1:NFrames
    % the loop of 
    for iLame = 1: length(obj.lameBounds{iFrame}) % --------- lame
        for iCell = 1:obj.tracks.frames(iFrame).cellCount % ----- cell
            if ~isempty(intersect(obj.tracks.frames(iFrame).bounds{iCell},obj.lameBounds{iFrame}{iLame}))
                Label_lame{iFrame}{iLame} = iCell ;
            else
                Distance{iLame}(iCell,1) = ((real(Center_lame{iFrame}{iLame})-Center_Cell{iFrame}{iCell})^2 ...
                       +imag(Center_lame{iFrame}{iLame}-Center_Cell{iFrame}{iCell})^2);    
            end
        end
        if Label_lame{iFrame}{iLame} == 0;
           [MinD,d] = sort(Distance{iLame});          
           Label_lame{iFrame}{iLame} = d(1);
           if (MinD(2)-MinD(1) < 100)
               Label_lame{iFrame}{iLame}=[Label_lame{iFrame}{iLame},d(2)];
           end
                   
        end
    end
end

%% sort out
for iFrame = 1:NFrames
    CLbounds{iFrame}={};
    for iCell = 1:obj.tracks.frames(iFrame).cellCount
        cc = 0;
        for iLame = 1:length(obj.lameBounds{iFrame})
            if ~isempty(find(Label_lame{iFrame}{iLame} == iCell))
               cc = cc+1;             
               CLbounds{iFrame}{iCell}{cc}= obj.lameBounds{iFrame}{iLame};%(:,2) is x, -(:,1) is y
            else
                continue;
            end
        end
        NLame{iFrame}{iCell} = cc; %the no. of lemollipodia for each cell
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









                       
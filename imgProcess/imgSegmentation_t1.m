clear all;
clc;
close all;

%% ------read the data ----------------------------------------------------
input = 'J21-F5';
addpath([input,'/']);
addpath('imgFun/');
num = dir([input,'/*.jpg']);
NFrames = numel(num);% no. of frames

%% ---------figure --------------------------------------------------------
% f1 = figure;
% colordef(f1,'white');
% set(gcf,'Color',[1,1,1]);
% hold on
% set(gcf,'Units','normalized');
% % set(gcf,'Position',[0,0,0.8,1])
% % axis([150 800 250 800]);
% axis equal;
%--------------------------------------------------------------------------

m = msgbox(['Image Processing of Frame: ' num2str(0) ' of ', num2str(NFrames)],'Image Processing');
set(findobj(m,'style','pushbutton'),'Visible','off')


for i = 1:NFrames
    
    set(findobj(m,'Tag','MessageBox'), ...
        'String', ['   Image Processing of Frame: ' num2str(i) ' of ' num2str(NFrames)]);
    drawnow()
    
   

    I = imread(['T000', num2str(i),'.jpg']);
    Ir = rgb2gray(I);
    img{i} = Ir;
    Ir = im2double(Ir);
% -------------- background marker ---------------%    
%     figure(1)
%     imshow(Ir)
    Ir2 = adapthisteq(Ir,'Cliplimit',0.5);
    
%     figure
%     imshow(Ir2)
    
    Ir1 = imadjust(Ir,[0;0.1],[0,1],3);
    Ir1 = imfill(Ir1);
    
%     figure(2)
%     imshow(Ir1)
%     
    w=gausswin(2,0.3);  % you'll have to play with N and alpha
    Ir1 = imfilter(Ir1,w,'same','symmetric'); % something like these options

    bw1 = im2bw(Ir1,0.6*graythresh(Ir1));
    bw1 = bwareaopen(bw1,80);
    
%     figure(3)
%     imshow(~bw1)
    
    bwB = bwperim(bw1,8);

    overLayCell = imoverlay(Ir,bwB,[0 0 0]);
    
%     figure(4)
%     imshow(overLayCell);
%  ------------foreground marker ----- -----------------  %
    
    fr1 = imextendedmax(img{i},80);    %BW
%     figure(5)
%     imshow(fr1);
    
    fr2 = imfill(fr1,'holes');
    se = strel('disk',4);
    fr2 = imdilate(imerode(fr2,se),se);
%     figure(6)
%     imshow(fr2)
    se1 = strel('disk',2);
    fr3 = imerode(fr2,se1);
    fr3 = bwareaopen(fr3,40);

%     figure(7)
%     imshow(fr3)
%         
    
    overLayCell2 = imoverlay(img{i}, bwB | fr3, [.3 1 .3]);
%     figure(8)
%     imshow(overLayCell2)
    
    % --------------watershed--------------------------%
   Ir2 = rgb2gray(overLayCell);
%    figure
%    imshow(Ir2)
   Ieq_c = imcomplement(Ir2);
       

%     figure(9)
%     imshow(Ieq_c)
    I_mod_c = imimposemin(Ieq_c, ~bw1|fr3);
    L_c = watershed(I_mod_c);
         
%     figure(1) 
%     imshow(label2rgb(L_c))
% %    
       
% -------------------------------------
    Nc = max(max(L_c));
%     Nc = temp(end);
    ct = 0;
    for t = 1:Nc 

   

        if length(find(L_c==t))>40 & length(find(L_c==t))< 8000
            ct = ct+1;
        else
            continue;
        end
        t1 = label2rgb((L_c == t),'gray');
        t1 = im2double(rgb2gray(t1));
        t2 = t1 + Ir; %
% % 
%     figure(10) 
%     imshow(t2)
    
        se1 = strel('disk',2);
        t3 = im2bw(t2,0.6*graythresh(t2));
        t3 = imcomplement(imerode(imdilate(t3,se1),se1));
        b1 = bwboundaries(t3);
%          
%         figure(1)
%         imshow(t3)
      

        NLame{i}{ct} = length(b1);
        if length(b1) > 0 
            for n = 1:NLame{i}{ct}
                boundsLame{i}{ct}{n} = b1{n,1}(:,2)+j*b1{n,1}(:,1);
            end
        else
               boundsLame{i}{ct} = {};
         
        end
 

        
        t4 = xor(imcomplement(t1),t3);
        t4 = bwareaopen(t4,80); 
%         
%         figure(2)
%         imshow(t4)
    if ct == 1;
        II{i} = t4;
    else
        II{i} = II{i}+t4;
    end
    
 % -------------------cell nuclear ----------------------%   
        b2 = bwboundaries(t4);
        if length(b2) > 1
            
           idx = 1;
           areas = regionprops(t4,'area');
           for ci = 2:length(areas)
               if areas(ci,1).Area > areas(idx,1).Area
                   idx = ci;
               end
           end
            cellBounds{i}{ct} = b2{idx}(:,2)+j*b2{idx}(:,1);
            
        elseif length(b2)==1 
      
            cellBounds{i}{ct} = b2{1}(:,2)+j*b2{1}(:,1);
        else           
            boundsLame{i}{ct} = [];
            ct = ct - 1;
        end
  % --------------------------------------------------------
     clear b1 b2    ;   
    end
%         w=gausswin(2,0.3);  % you'll have to play with N and alpha
%     II{i} = imfilter(II{i},w,'same','symmetric'); % something like these options

    II{i} = bwlabel(II{i});
% 
%     figure
%     imshow(II{i})
end


for i = 1:NFrames
    % pad array with zeros
    I1{i} = padarray(II{i},[285 200]);
%     number of pixels in imaiop[]i8o9/0ge
    NPix = size(I1{i},1);
    % sparse version of image i
    [rows cols] = find(I1{i}~=1 & I1{i}~=0);
    % store cells as ones in sparse matrix
    cellImage{i} = sparse(rows,cols,ones(length(rows),1),NPix,NPix);
end
% figure
% imshow(full(cellImage{1}))
f1 = [input,'-cellImage'];
save (f1, 'cellImage');
f2 = [input,'-lamellipodia'];
save (f2, 'boundsLame','NLame','cellBounds');
% 
figure(2)                                 



for iFrame = 1:NFrames
iFrame
    cla;
    imshow(img{iFrame})

    hold on
    for iCell = 1:length(cellBounds{iFrame})
        plot(cellBounds{iFrame}{iCell},'r','LineWidth',1);
        for n = 1:NLame{iFrame}{iCell}
            plot(boundsLame{iFrame}{iCell}{n},'y','LineWidth',1);
        end
        
        pause;
    
    end
    pause;
end

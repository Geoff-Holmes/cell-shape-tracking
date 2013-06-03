function [q,omega,assign]=auction_c(costm)
%%%In the "cost" matrix supply -Inf at for measurements which are outside 
%%%the gates for corresponding tracks
%%%all costs are +ve that is its better to have an association (if possible) than 
%%%starting a new track

%%% code from Thamas, McMaster

[n_track,n_list]=size(costm);


AUCTION_2D_SCALE=0.25;
AUCTION_2D_MAXTHRESH=100;
AUCTION_2D_MAXC=1000.0;
AUCTION_2D_STARTINCR=1;
AUCTION_2D_SMALL=-33554432;
AUCTION_2D_FACTOR=8;
AUCTION_2D_INCRFACTOR=2;
AUCTION_2D_ENDEPS=1;
delta=10^(-30);
count=1;
MIN=Inf;
for i=1:n_track
   fin(i)=count;%%%fin keeps start position in the cost or list for a particular track
   for j=1:n_list
      if(costm(i,j)~=-Inf)
         MIN=min(costm(i,j)*1000,MIN);
         cost(count)=-costm(i,j)*1000; %%%the cost for associating i th track to the j th measurement
         start(count)=j; %%%the measurement
         count=count+1;
      end
   end
end

if(MIN<0)
   cost=cost+MIN-delta;
end
fin(n_track+1)=count;

epsilon= round(max((n_track+1)*AUCTION_2D_SCALE*AUCTION_2D_MAXC,1));
thresh=min(round(n_track/5),AUCTION_2D_MAXTHRESH);
startincr=AUCTION_2D_STARTINCR;

assign=zeros(1,n_list);
pcol=zeros(1,n_list);
curlist=1:n_track;

numnew=n_track;

while(1)
   incr=min(startincr,epsilon);
   while(numnew>thresh | ((numnew>0)&(epsilon==1)))
      nolist=numnew;
      numnew=0;
      for i=1:nolist
         row=curlist(i);
         max1=0;
         max2=0;
         bstcol=0;
         for j=fin(row):fin(row+1)-1
            tmax=pcol(start(j))-cost(j);
            if(tmax>max2)
               if(tmax>max1)
                  max2=max1;
                  max1=tmax;
                  bstcol=start(j);
               else
                  max2=tmax;
               end
            end
         end
         if(bstcol)
            pcol(bstcol)=pcol(bstcol)-(max1-max2+incr);
            oldrow=assign(bstcol);
            assign(bstcol)=row;
            
            if(oldrow)
               curlist(numnew+1)=oldrow;
               numnew=numnew+1;
            end
         end %%if(bstcol)
      end %%for i=1:nolist
      incr=min(incr*AUCTION_2D_INCRFACTOR,epsilon);
   end %%%while(numnew>thresh | (numnew>0)&(epsilon==1))
   
   if(epsilon==1)
      break;
   end
   
   epsilon=epsilon/AUCTION_2D_FACTOR;
   if(epsilon>incr)
      epsilon=epsilon/AUCTION_2D_FACTOR;
   end
   if((epsilon<1)|(epsilon<AUCTION_2D_FACTOR))
      epsilon=1;
   end
   thresh=thresh/AUCTION_2D_FACTOR;
   
   for j=1:n_list
      if(assign(j))
         row=assign(j);
         max1=AUCTION_2D_SMALL;
         max2=AUCTION_2D_SMALL;
         for jj=fin(row):fin(row+1)-1
            tmax=pcol(start(jj))-cost(jj);
            if(start(jj)==j)
               max1=tmax;
            else
               max2=tmax;
            end
         end
         if(max1<max2)
            curlist(numnew+1)=assign(j);
            assign(j)=0;
            pcol(j)=0;
            numnew=numnew+1;
         end
      else
         pcol(j)=0;
      end
   end
   
   if(startincr < epsilon)
      startincr=AUCTION_2D_FACTOR*startincr;
   end
end %%%while(1)
%%%%Assignment done

%%%prepareing output
q=0;
omega=zeros(n_track,n_list);
for i=1:n_list
   if(assign(i))
      q=q+costm(assign(i),i);
      omega(assign(i),i)=1;
   end
end
% assign=assign';
   
return

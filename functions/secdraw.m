function [xx, yy] = secdraw(start_angle, sector_angle, radius,c)

%  usage: [xx, yy]  = secdraw(start_angle, sector_angle, radius, color/transparent degree)
%%

theta0 = 0;              % offset angle in radians
theta1 = start_angle;    % starting angle in radians
theta  = sector_angle;   % central angle in radians

angle_ratio = theta/(2*pi);     % ratio of the sector to the complete circle
rho = abs(radius);              % abs(...) can be removed
MaxPts = 100;                   % maximum number of points in a whole circle.
                                % if set to small # (e.g 10) the resolution
                                % of the curve will be poor. 
                                % generally values greater than 50
                                % will give (very) good resolution

n = abs( ceil( MaxPts*angle_ratio ) );
r = [ 0; rho*ones(n+1,1); 0 ];
theta = theta0 + theta1 + [ 0; angle_ratio*(0:n)'/n; 0 ]*2*pi;

% output
[xx,yy] = pol2cart(theta,r);

% plot if not enough output variable are given
if c <5;
col = ['r','c','y','b'];% color
deg = [0.5 0.5 0.5 0.2];%transparent degree
if nargout < 2,
    hh=patch(xx, yy, col(c),'EdgeColor',col(c),'AlphaDataMapping','none','FaceAlpha',deg(c));
end
else
   col = colormap(jet(128));
   k = rem(c-4,128);
   if k==0
      k = k+1
   end
   hh=patch(xx, yy, col(k,:),'EdgeColor',col(k,:),'AlphaDataMapping','none','FaceAlpha',0.1);
end
    
end
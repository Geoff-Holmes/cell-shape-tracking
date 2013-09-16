% animation control script.  The calling code must have already specified 
% variables:
% t = 1;            % current / starting frame frame
% T = dataLength;   % final frame
% abort = 0;        % stopping flag
% tic;              % i.e. initiate timer
%
% The script should come within the loop:
% while ~abort
%  ...
% end
%
% This script then advaces the frame with a pause specified by the user 
% clicking in the control frame (see below) as follows:
%
%                           abort
% 
%       x |  fast forward             
%       ^ |                           step forward   
%       | |  slow forward 
% first   |                                           final
% frame   |  slow reverse                             frame
%         |                                             
%         |  fast reverse             step reverse
%         |
%         |________________________________________
%        0                                     -> y
%                            abort
%
% the control frame is the frame most recently referenced by the calling
% animation code.

if t == 1 || t == T
    waitforbuttonpress
end

xl = get(gca, 'XLim');
yl = get(gca, 'YLim');
x0 = sum(xl)/2;
y0 = sum(yl)/2;
xScl = xl(2)-x0;
yScl = yl(2)-y0;    

C = get (gca, 'CurrentPoint');
x = C(1,1);
y = C(1,2);

if abs((y-y0)/yScl) > 1
    abort = 1;
else if abs((x-x0)/xScl) > 1
        if x < xl(1)
            t = 1;
        else 
            t = T;
        end
    else                
        dt = sign(y-y0);
        t = t + dt;
        t = max(1,t);
        t = min(t,T);

        if x > x0
            pse = 0;
        else
            pse = .51 - abs((y0 - y)/yScl/2);
        end

        if x < x0
            if toc < pse
                pause(pse-toc)
            end
        else
    %         pause()
            waitforbuttonpress  
        end
    end
end
tic
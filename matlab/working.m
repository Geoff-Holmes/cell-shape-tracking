% function Mg = working(iCell)
% 
% if nargin == 0, iCell = 6; end

clear all

% initialise spline
B = grhBspline();

cd ~/Dropbox/activeContours/matlab/
data = 'neutroImages_Phil_XYpoint7';

% ? constant velocity model
% M = grhModel(eye(2*B.L), zeros(1,2*B.L), 10*eye(2*B.L), 2);

% for random walk model
% A = eye(B.L);
% C = [];
% W = 10*eye(B.L);
% v = 5;
% for constant velocity model
dt = 1;
A = [eye(B.L) dt*eye(B.L); zeros(B.L) eye(B.L)];
C = []; 
Q  = 10 * gallery('tridiag', ones(1,B.L-1), 2*ones(1,B.L), ones(1,B.L-1))/2;
G = [dt^2/2*eye(B.L); dt*eye(B.L)];
W = G * Q * G';
v = 5;

M = grhModel(A, C, W, v);

H = grhImageHandler(0,45);

Mg = grhManager(B, M, H, @correspondNN, 75, data);
clear B M H data

Mg = Mg.firstFrame();
Mg.iterate();

figure; hold on
axis([200 1100 550 950])

% for t = 1:40
%     
%     for j = 1:length(Mg.cells)
%         
%         thisCell = Mg.cells{j};
%         if thisCell.firstSeen <= t && thisCell.lastSeen >= t
%             p(j) = plot(thisCell, t-thisCell.firstSeen+1);
%             axis([200 1100 550 950]); hold on
%         end
%     end
%     pause(0.01)
%     hold off
% %     delete(p)
% end
% % 
% for i = 1:length(Mg.cells)
%     
%     thisCell = Mg.cells{i};
%      hold on;
%     
%     for j = 1:thisCell.lastSeen - thisCell.firstSeen
%         
%         p1 = plot(thisCell, j);
% 
%         hold on 
%         try
%         p2 = plot(Mg.frames{j+thisCell.firstSeen -1}.bounds{thisCell.obsRefs(j)}, 'r');
%         catch ex
%             ex
%         end
%         c = 10*round(thisCell.centroid(1)/10);
%         text(real(c), imag(c)+50, num2str(i))
%         title(['Cell ' num2str(i)]); axis([200 1100 550 950]);
%         pause(0.05)
%         hold off
%     end
%     
% end
% 
% n=1;
% for i = 2:23
% plot(Mg.cells{n}.snake(i))
% C = Mg.cells{n}.Cmatrix{i};
% state = Mg.cells{n}.states{i};
% v = Mg.cells{n}.Cmatrix{i} * state(Mg.Bspline.L+1:end);
% c = Mg.cells{n}.snake(i).curve(-length(v));v = v(1:end-1);
% line(real(conj([c c+v]')), imag(conj([c c+v]')))
% hold on
% plot(Mg.cells{n}.snake(i+1), 'r'); 
% pause()
% hold off
% end

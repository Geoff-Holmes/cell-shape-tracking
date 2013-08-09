function [FD] = getAllFourierDescriptors(obj, Npoints)

% create an array containing all fourier descriptors from data
% each FD row has form : [track trackpoint FD]

if nargin == 1
    Npoints = 33;
end

n = 1;

for i = 1:obj.Ntracks
    
    iCell = obj.cells(i);
    
    for j = 1:length(iCell.snake)
        
        FD(n,:) = [i j iCell.snake(j).fourierDescriptor(Npoints)'];
        n = n + 1;
    end
end
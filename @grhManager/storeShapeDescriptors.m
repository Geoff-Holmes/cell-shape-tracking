function storeShapeDescriptors(obj, SDtype)

% storeShapeDescriptors(obj, SDtype)
%
% add shape descriptor information to each snake in each track
%
% SDtype == 'PCAonFD' :
%   Compute the fourier descriptors of all cell snakes
%   Project this data in FD space onto the pricipla components

if nargin == 1
    SDtype = 'PCAonFD';
end

switch SDtype
    
    case 'FD'
        
        prompt = {'How many shape boundary points?'};
        ans = inputdlg(prompt, 'Input', 1, {'100'});
        Npoints = str2num(ans{1});
        
        for i = 1:obj.Ntracks
            iCell = obj.cells(i);
            for j = 1:length(iCell.snake)
                iCell.snake(j).shapeDescriptor ...
                    = iCell.snake(j).fourierDescriptor(Npoints)';
            end
        end

    case 'PCAonFD'

        prompt = {'How many shape boundary points?', 'How many PCA components?'};
        ans = inputdlg(prompt, 'Input', 1, {'100', '3'});
        Npoints = str2num(ans{1});
        Npcs = str2num(ans{2});

        [PC, info] = obj.PCAonFDs(Npcs, Npoints);
        % store limits of shape space
        obj.shapeDescriptorLims = [prctile(PC,1); prctile(PC,99)];

        assert(size(PC,1)==size(info,1))
        % store shape descriptor in each snake
        for i = 1:length(PC)
            obj.cells(info(i,1)).snake(info(i,2)).shapeDescriptor = PC(i,:);
        end   
    
    otherwise
        display('Unknown shape descriptor or code not written yet.')
end
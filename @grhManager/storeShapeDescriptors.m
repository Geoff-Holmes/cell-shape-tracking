function storeShapeDescriptors(obj, SDtype)

% add shape descriptor information to each snake in each track

if nargin == 1
    SDtype = 'PCAonFD';
end

if strcmp(SDtype, 'PCAonFD')
   
    prompt = {'How many shape boundary points?', 'How many PCA components?'};
    ans = inputdlg(prompt, 'Input', 1, {'33', '3'});
    Npoints = str2num(ans{1})
    Npcs = str2num(ans{2});
    
    
    [PC, info] = obj.PCAonFDs(Npcs, Npoints);
    
    assert(size(PC,1)==size(info,1))
    for i = 1:length(PC)
        obj.cells(info(i,1)).snake(info(i,2)).shapeDescriptor = PC(i,:);
    end   
    
else
    display('Unknown shape descriptor or code not written yet.')
end
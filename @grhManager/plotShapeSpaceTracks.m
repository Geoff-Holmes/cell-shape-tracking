function plotShapeSpaceTracks(obj, tracks)

% plotAllShapeSpaceTracks(obj, tracks)
%

if nargin == 1
    tracks = 1:obj.Ntracks;
end

% get shape descriptor data if needed
if ~length(obj.shapeDescriptorLims)
    obj.storeShapeDescriptors;
end

[rws, cls] = grhOptSubPlots(length(tracks));

for i = 1:length(tracks)
    
    subplot(rws,cls,i)
    
    for t = 1:length(obj.cells(tracks(i)).snake)
        
        plotData(t,:) = obj.cells(tracks(i)).snake(t).shapeDescriptor;
        
    end
    
    plot(plotData(:,1), plotData(:,2))
    axis(obj.shapeDescriptorLims(1:4))
    clear plotData
    
end
        
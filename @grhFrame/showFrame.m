function showFrame(obj, varargin)

for i = 1:length(varargin)
    switch varargin{i}
        case 'B'
            obj.plotBounds(0)
        case 'C'
            obj.plotCentroids(0)
        case 'S'
            
    end
end
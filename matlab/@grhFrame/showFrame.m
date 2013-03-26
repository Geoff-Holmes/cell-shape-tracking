function showFrame(obj, varargin)

for i = 1:length(varargin)
    switch varargin{i}
        case 'B'
            obj.plotBounds()
        case 'C'
            obj.plotCentroids()
        case 'S'
            
    end
end
classdef grhFrame
    
    % observation object
    
    properties
        
        bounds;
        centroids;
        cellCount;
        cellCtrlPts;
        
    end
    
    methods
        
        function obj = grhFrame(bounds, centroids)
            obj.bounds = bounds;
            obj.centroids = centroids;
            obj.cellCount = length(centroids);
        end
    end
end
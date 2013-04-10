classdef grhCell < handle
    
    properties
        
        id;
        firstSeen;
        lastSeen;
        ctrlPts;     % list 
        covariance;  % list
        centroid;    % list
        obsRefs;     % list of observations allocated to this cell
        Bspline;
        
        
    end
    
    methods
        
        function obj = grhCell(id, firstSeen, Bspline, ctrlPts, covariance, centroid, obsRefs)
            
            obj. id = id;
            obj.firstSeen = firstSeen;
            obj.lastSeen = firstSeen;
            obj.Bspline = Bspline;
            obj.ctrlPts{1} = ctrlPts;
            obj.covariance{1} = covariance;
            obj.centroid(1) = centroid;
            obj.obsRefs(1) = obsRefs;
        end
        
    end
    
end
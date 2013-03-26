classdef grhCell
    
    properties
        
        id;
        firstSeen;
        lastSeen;
        ctrlPts;     % list 
        covariance;  % list
        obsRefs;     % list of observations allocated to this cell
        Bspline = grhBspline();
        
        
    end
    
    methods
        
        function obj = grhCell(id, firstSeen, ctrlPts, covariance, obsRefs)
            
            obj. id = id;
            obj.firstSeen = firstSeen;
            obj.lastSeen = firstSeen;
            obj.ctrlPts{1} = ctrlPts;
            obj.covariance{1} = covariance;
            obj.obsRefs(1) = obsRefs;
        end
        
    end
    
end
classdef grhSnake
    
    properties
        
        ctrlPts;
        Bspline;
        
    end
    
    methods
        
        function obj = grhSnake(ctrlPts, Bspline)
            
            obj.ctrlPts = ctrlPts;
            obj.Bspline = Bspline;
            
        end
        
    end
    
end
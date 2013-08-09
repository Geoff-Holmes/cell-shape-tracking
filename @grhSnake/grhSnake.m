classdef grhSnake
    
    properties
        
        ctrlPts;
        Bspline;
        shapeDescriptor;
        
    end
    
    methods
        
        function obj = grhSnake(ctrlPts, Bspline)
            
            obj.ctrlPts = ctrlPts;
            obj.Bspline = Bspline;
            
        end
        
    end
    
end
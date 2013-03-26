classdef grhImageHandler
    
    properties
        minBoundaryThresh = 40;
        minAreaThresh = 100;
    end
    
    methods
        
        function obj = grhImageHandler(threshB, threshA)
            % construct image handler
            if nargin
                obj.minBoundaryThresh = threshB;
                if nargin > 1
                    obj.minAreaThresh = threshA;
                end
            end
        end
    end
end
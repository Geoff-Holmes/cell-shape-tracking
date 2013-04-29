classdef grhImageHandler
    
    properties
        minBoundaryThresh = 40;
        minAreaThresh = 100;
    end
    
    methods
        
        function obj = grhImageHandler(threshB, threshA)
            % construct image handler
            % threshB is minimum boundary threshold
            % threshA is minimum area threshold
            if nargin
                obj.minBoundaryThresh = threshB;
                if nargin > 1
                    obj.minAreaThresh = threshA;
                end
            end
        end
    end
end
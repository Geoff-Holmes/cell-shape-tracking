classdef grhCell < handle
    
    properties
        
        id;
        firstSeen;
        lastSeen;
        snake;          % list 
        ctrlVelocities  % cell
        Cmatrix         % cell
        covariance;     % cell
        centroid;       % list
        obsRefs;        % list of observations allocated to this cell
        centroidShift;  %list
        Bspline;
        
        
    end
    
    methods
        
        function obj = grhCell(id, firstSeen, Bspline, ctrlPts, ...
                covariance, centroid, obsRefs, ctrlVelocities)
            
            obj. id = id;
            obj.firstSeen = firstSeen;
            obj.lastSeen = firstSeen;
            obj.Bspline = Bspline;
            obj.snake = grhSnake(ctrlPts, obj.Bspline);
            obj.covariance{1} = covariance;
            obj.centroid(1) = centroid;
            obj.obsRefs(1) = obsRefs;
            obj.centroidShift(1) = 0;
            if nargin == 7
                ctrlVelocities = zeros(obj.Bspline.L, 1);
            end
            obj.ctrlVelocities{1} = ctrlVelocities;
            obj.Cmatrix{1} = [];
        end
        
    end
    
end
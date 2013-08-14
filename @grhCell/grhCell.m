classdef grhCell < handle
    
    properties
        
        id;
        firstSeen;
        lastSeen;
        snake;          % list 
        states;         % cell
        Cmatrix         % cell
        covariance;     % cell
        centroid;       % list
        % obj.centroid stores centroid of segmented observation
        % whereas obj.getCentroidT returns centroid calculated from snake
        % they are not the same!
        obsRefs;        % list of observations allocated to this cell
        centroidShift;  % list
        Bspline;
        smoothed = 0;   % flag
        
        
    end
    
    methods
        
        function obj = grhCell(id, firstSeen, Bspline, ctrlPts, ...
                covariance, centroid, obsRefs, states, Cmatrix)
            
            obj. id = id;
            obj.firstSeen = firstSeen;
            obj.lastSeen = firstSeen;
            obj.Bspline = Bspline;
            obj.snake = grhSnake(ctrlPts, obj.Bspline);
            obj.covariance{1} = covariance;
            obj.centroid(1) = centroid;
            obj.obsRefs(1) = obsRefs;
            obj.centroidShift(1) = 0;
            obj.states{1} = states;
            obj.Cmatrix{1} = Cmatrix;
        end
        
    end
    
end
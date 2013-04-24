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
        obsRefs;        % list of observations allocated to this cell
        centroidShift;  %list
        Bspline;
        
        
    end
    
    methods
        
        function obj = grhCell(id, firstSeen, Bspline, ctrlPts, ...
                covariance, centroid, obsRefs, states)
            
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
                obj.states = zeros(obj.Bspline.L, 1);
            else
                obj.states{1} = states;
            end
            obj.Cmatrix{1} = [];
        end
        
    end
    
end
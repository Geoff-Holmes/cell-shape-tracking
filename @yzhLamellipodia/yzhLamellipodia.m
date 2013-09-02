classdef yzhLamellipodia<handle
    
    properties
    lameBounds      % boundaries of lamellipodia lameBounds{iiFrame}
    tracks          % tracking results of cell main body
    NLame           % NLame{iiFrame}{iiCell} the no of lamellipodia each cell has
    CLbounds        % CLbounds{iiFrame}{iiCell}{cc} boundaries of lamellipodia in each cell 
    lameLoc = {}    % lameLoc{iCell}{iFrame} each cell in each frame the distribution of lamellipodia
                    % The same as tracks. 
                    % iiFrame = iFrame+thisCell.firstSeen-1;
    end
    
    
    methods
        function obj = yzhLamellipodia(lameBoundsFile,trackResults)
           
            addpath('../saveMat');
            addpath('/Users/Yang/Dropbox/Public/yzhMATLAB/Geoff_Code/saveMat');
            load(lameBoundsFile); 
            load(trackResults);
            N = length(lameBounds);
            for iFrame = 1:N
                n = length(lameBounds{iFrame});
                for j = 1:n
                    thisBounds = lameBounds{iFrame}{j};
                    boundsLame{iFrame}{j} = lameBounds{iFrame}{j}+200+285i;
                end
            end
            obj.lameBounds = boundsLame;
            obj.tracks = Mg; 
            obj.NLame = [];
            obj.CLbounds = [];
        end
    end
end
            







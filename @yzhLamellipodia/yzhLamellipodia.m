classdef yzhLamellipodia<handle
    
    properties
    lameBounds      % boundaries of lamellipodia
    tracks          % tracking results of cell main body
    NLame           %NLame{iFrame}{iCell} the no of lamellipodia each cell has
    CLbounds        %CLbounds{iFrame}{iCell}{cc} boundaries of lamellipodia in each cell 
    lameLocation    % lameLocation{iCell}{iFrame} each cell in each frame the distribution of lamellipodia
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
            obj.lameLocation = [];
        end
    end
end
            







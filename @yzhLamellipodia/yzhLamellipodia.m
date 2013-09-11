classdef yzhLamellipodia<handle
    
    properties
    lameBounds      % boundaries of lamellipodia lameBounds{iiFrame}
    tracks          % tracking results of cell main body
    NLame           % NLame{iiFrame}{iiCell} the no of lamellipodia each cell has
    CLbounds        % CLbounds{iiFrame}{iiCell}{cc} boundaries of lamellipodia in each cell 
    lameLoc = {}    % lameLoc{iCell}{iFrame} each cell in each frame the distribution of lamellipodia
                    % The same as tracks. 
                    % iiFrame = iFrame+thisCell.firstSeen-1;
    refCellBounds   % refer to lameBounds
    end
    
    
    methods
        function obj = yzhLamellipodia(lameBoundsFile,trackResults)
           
            addpath('..\saveMat');
            addpath('C:\Users\uos\Dropbox\Public\yzhMATLAB\cell-shape-tracking-develop\saveMat');
            load(lameBoundsFile); 
            load(trackResults);
            N = length(boundsLame);
            
            for iFrame = 1:N
%                 iFrame
                n = length(cellBounds{iFrame});
                for j = 1:n
                   cellBs{iFrame}{j} = cellBounds{iFrame}{j}+200+285i;
                    if ~isempty((boundsLame{iFrame}{j}))
                           for k = 1:length(boundsLame{iFrame}{j})
                               lameBs{iFrame}{j}{k} = boundsLame{iFrame}{j}{k}+200+285i;
                           end
                     else
                         lameBs{iFrame}{j} ={};
                    end
                    
                end
            end

            
            obj.lameBounds = lameBs;
            obj.tracks = Mg; 
            obj.NLame = {};
            obj.CLbounds = {};
            obj.refCellBounds = cellBs;
        end
    end
end
            







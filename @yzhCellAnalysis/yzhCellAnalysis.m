classdef yzhCellAnalysis < handle
    
    properties
        lames                         %  results from La = yzhLamellipodia()
        cellTracks                    %   tracking result = lame.tracks
        orientation                   %   front(1)-back(-1)-side(0) orientation{iCell}{iFrame}
        anglePP                       %   the angle between cell front point and points on the boundary
        longTracks                    %   
    end
    methods
        function obj = yzhCellAnalysis(cellTracks,lames)
            % Ay = yzhCellAnalysis(cellTracks,lames)
            % cellTracks is the results from tracking 'Mg'
            % lame is the results from lamellipodia anaylsis 'La'
            obj.lames = lames;
            obj.cellTracks = cellTracks ;
            longTracks = cellTracks.showInfo;
            obj.orientation = {};
            obj.anglePP = {};
        end
    end
end
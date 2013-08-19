classdef grhManager < handle
    
    properties
        Bspline;
        Model;
        ImageHandler;
        corresponder; % function handle
        dataName;
        Data;
        DataL;
        DataXYlims;
        maxMoveThresh;
        
        frames;
        cells;
        Ntracks = 0;
        info    = 0;
        shapeDescriptorLims;
        
        notes;
        
    end
        
    methods
        
        function obj ...
                = grhManager(Bspline, Model, ImageHandler, ...
                corresponder, maxMoveThresh, dataName, notes)
            
            obj.Bspline = Bspline;
            obj.Model = Model;
            obj.ImageHandler = ImageHandler;
            % check
            if obj.ImageHandler.minBoundaryThresh < obj.Bspline.L
                obj.ImageHandler.minBoundaryThresh = obj.Bspline.L;
            end
            obj.corresponder = corresponder;
            obj.maxMoveThresh = maxMoveThresh;
            % load data
            obj.dataName = dataName;
%             temp = load(Data);
%             tempField = fieldnames(temp);
            obj.Data = importdata([dataName '.mat']);
            obj.DataL = length(obj.Data);
            obj.DataXYlims = size(obj.Data{1});
            if nargin > 6
                obj.notes = notes;
            end
            
        end
        
    end
    
end
    
    
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
        
    end
        
    methods
        
        function obj ...
                = grhManager(Bspline, Model, ImageHandler, ...
                corresponder, maxMoveThresh, dataName)
            
            obj.Bspline = Bspline;
            obj.Model = Model;
            obj.ImageHandler = ImageHandler;
            obj.corresponder = corresponder;
            obj.maxMoveThresh = maxMoveThresh;
            % load data
            obj.dataName = dataName;
%             temp = load(Data);
%             tempField = fieldnames(temp);
            obj.Data = importdata([dataName '.mat']);
            obj.DataL = length(obj.Data);
            obj.DataXYlims = size(obj.Data{1});
            
        end
        
    end
    
end
    
    
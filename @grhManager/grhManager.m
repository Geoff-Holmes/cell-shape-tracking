classdef grhManager < handle
    
    properties
        Bspline;
        Model;
        ImageHandler;
        corresponder; % function handle
        Data;
        DataL;
        maxMoveThresh;
        
        frames;
        cells;
        Ntracks;
        
    end
        
    methods
        
        function obj ...
                = grhManager(Bspline, Model, ImageHandler, ...
                corresponder, maxMoveThresh, Data)
            
            obj.Bspline = Bspline;
            obj.Model = Model;
            obj.ImageHandler = ImageHandler;
            obj.corresponder = corresponder;
            obj.maxMoveThresh = maxMoveThresh;
            % load and unpack data
            temp = load(Data);
            tempField = fieldnames(temp);
            obj.Data = temp.(tempField{1});
            obj.DataL = length(obj.Data);
            obj.Ntracks = 0;
            
        end
        
    end
    
end
    
    
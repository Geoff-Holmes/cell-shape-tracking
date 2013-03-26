classdef grhManager
    
    properties
        Bspline;
        Model;
        ImageHandler;
        Data;
        DataL;
        
        maxMoveThresh = 30;
        
        frames;
        centroidDistances;
        cells;
        liveTracks;
        
    end
        
    methods
        
        function obj = grhManager(Bspline, Model, ImageHandler, Data)
            
            obj.Bspline = Bspline;
            obj.Model = Model;
            obj.ImageHandler = ImageHandler;
            % load and unpack data
            temp = load(Data);
            tempField = fieldnames(temp);
            obj.Data = temp.(tempField{1});
            obj.DataL = length(obj.Data);
            
        end
        
    end
    
end
    
    
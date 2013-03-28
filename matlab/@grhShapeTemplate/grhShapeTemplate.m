classdef grhShapeTemplate < grhSnake
    
    properties
        
        W;
        H;
        Wplus;
        
    end
    
    methods
        
        function obj = grhShapeTemplate(Q0, Bspline, shapeSpace)
            
            obj = obj@grhSnake(Q0, Bspline);
            
            switch shapeSpace
                case 'euclideanSimilarities'
                    display('This shape space is not yet defined')
                    
                case 'planarAffine'
                    Qx = real(Q0);
                    Qy = imag(Q0);
                    Z = zeros(obj.Bspline.L, 1);
                    I = ones(size(Z));
                    % transformation matrix Blake p.76
                    obj.W = [I Z Qx Z Z Qy; Z I Z Qy Qx Z];
                    % scale this matrix so columns are balanced
                    fac = mean(mean(abs(obj.W(:,3:end))));
                    obj.W(:,1:2) = obj.W(:,1:2) * fac;
                    % curve metric matrix Blake p.59
                    B = obj.Bspline.MB;
                    Z = zeros(size(B));
                    U = [B Z; Z B];
                    % shape metric matrix Blake p.79
                    obj.H = obj.W' * U * obj.W;
                    % pseudo inverse Blake p.79
                    obj.Wplus = obj.H \ obj.W' * U;
            end
        end
    end
end
                
        
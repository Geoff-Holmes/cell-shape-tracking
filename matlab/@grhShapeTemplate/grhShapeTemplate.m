classdef grhShapeTemplate < grhSnake
    
    properties
        
        W;
        H;
        Wplus;
        Qx;
        Qy;
        
    end
    
    methods
        
        function obj = grhShapeTemplate(Q0, Bspline, shapeSpace)
            
            obj = obj@grhSnake(Q0, Bspline);
            obj.Qx = real(Q0);
            obj.Qy = imag(Q0);
            
            % curve metric matrix Blake p.59
            Z = zeros(size(obj.Bspline.MB));
            U = [obj.Bspline.MB Z; Z obj.Bspline.MB]; 
            
            % components for W
            Z = zeros(obj.Bspline.L, 1);
            I = ones(size(Z));
            
            switch shapeSpace
                
                case 'euclideanSimilarities'
                    % transformation matrix Blake p.75
                    obj.W = [I Z obj.Qx -obj.Qy; Z I obj.Qy obj.Qx];
                    
                case 'planarAffine'
                    % transformation matrix Blake p.76
                    obj.W = [I Z obj.Qx Z Z obj.Qy; Z I Z obj.Qy obj.Qx Z];
            end
            
            % scale this matrix so columns are balanced
            fac = mean(mean(abs(obj.W(:,3:end))));
            obj.W(:,1:2) = obj.W(:,1:2) * fac;
            % shape metric matrix Blake p.79
            obj.H = obj.W' * U * obj.W;
            % pseudo inverse Blake p.79
            obj.Wplus = obj.H \ obj.W' * U;
            
        end
    end
end
                
        
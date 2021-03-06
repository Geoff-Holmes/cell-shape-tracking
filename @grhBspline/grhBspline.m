classdef grhBspline < handle
    
    % periodic Bspline function
    % B = grhBspline()
    % B = grhBspline(L, d)
    %
    % B = grhBspline()
    % creates a Bspline object with 20 spans and dimension 4
    %
    % B = grhBspline(L, d)
    % to specify L spans and dimension d
    
    properties
        
        L    = 20; % length of spline range = number of bases
        d    =  4; % dimension of basis functions
        BS       ; % spline matrix - same for each span in this case
        G        ; % placement matrices
        BSG      ; % prodcut of BS*G{i} for each i
        bsig     ; % first function supported by each span
        P        ; % Hilbert matrix for metrics Blake p293
        MB       ; % metric matrix Blake p293
        P1       ; % Blake p293
        MA       ; % area matrix Blake p293
        
    end
    
    methods
        
        function obj = grhBspline(L, d)
            % constructor get matrices
            if(nargin > 0)
                obj.L    = L;
                obj.d    = d;
            end
            % load correct spline matrix
%             fl = ['_d' num2str(obj.d) '_L' num2str(obj.L) '_prdc'];
            fl = ['_d' num2str(obj.d) '_prdc'];
            temp   = load(['functions/splineMatrices/BS' fl]);
            obj.BS = temp.BS;
            % determine which basis is first for each span
            obj.bsig = [(obj.L-obj.d+2):obj.L 1:(obj.L-obj.d+1)];
            % construct placement matrices
            obj.G = zeros(obj.d, obj.L, obj.L);
            for k = 1:obj.L
                for i = 1:obj.d
                    % row i pick up bsig(k)+i-1th control point
                    j = obj.bsig(k) +i-1;
                    if j > obj.L
                        j = j - obj.L;
                    end
                    obj.G(i,j,k) = 1;
                end
                obj.BSG{k} = obj.BS * obj.G(:,:,k); 
            end
            % construct Hilbert matrix
            [temp2, temp1] = meshgrid(1:obj.d, 1:obj.d);
            obj.P = 1./(temp1 + temp2 - 1);
            % construct area "Hilbert matrix"
            obj.P1 = (temp2 - 1)./(temp1+temp2-2);
            obj.P1(1) = 0;
            clear temp1 temp2
            % construct metric matrix and area matrix
            obj.MB = zeros(obj.L);
            obj.MA = zeros(obj.L);
            for i = 1:obj.L
                temp1  = obj.G(:,:,i)' * obj.BS';
                temp2  = obj.BS * obj.G(:,:,i);
                obj.MB = obj.MB + temp1 * obj.P  * temp2;
                obj.MA = obj.MA + temp1 * obj.P1 * temp2;
            end
            obj.MB = obj.MB / obj.L;
%             obj.MA = obj.MA / obj.L; % discrepancy in Blake
        end
    end
end
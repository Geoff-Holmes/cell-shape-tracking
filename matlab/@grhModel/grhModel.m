classdef grhModel
    %    obj = grhModel(A, C, W, v)
    %
    % Create Model object for kalman filtering / smoothing
    %    Model:
    %     X(t+1) = AX(t) + w, w~N(0,W),
    %     Y(t)   = CX(t) + v, v~N(0,V), V = vI
    % 
    %    Other input / ouput:
    %     X is optimal posterior state estimate
    %     X(t) forms the input, X(t+1) is the output
    %     P is prior state covariance
    %     K is Kalman gain
    %     Q is latest posterior state covariance
    %     Q(t) forms the input, Q(t+1) is the output
    % 
    %    geoff.r.holmes@sheffield.ac.uk 28Feb13

    properties

        A; C; W; v; Sdim; 

    end

    methods

        function obj = grhModel(A, C, W, v)
            % construct model by defining matrices
            nA = size(A);
            nC = size(C);
            nW = size(W);
            assert(sum(nA==nW)==size(nA,2));
            assert(nA(1) == nC(2));
            if numel(v) > 1, v = v(1); end
            obj.A = A;
            obj.C = C;
            obj.W = W;
            obj.v = v;
            % store state dimension
            obj.Sdim = nA(1);
        end
    end
end
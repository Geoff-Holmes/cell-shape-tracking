function [X, P, Q, K] = Filter(obj, X0, Q, Y, C)
    
% get filtered state for model in obj
% X0 is intial state
% P is predicted covariance
% Q input is covariance of intial state
% Q output is corrected covariance
% Y is observation(s)

if nargin > 4
    obj.C = C;
end

szY = size(Y);
V = obj.v * eye(szY(1));

if szY(2) > 1

    display('code for batch filter not written')
%         % filer the whole sequence of observations
% 
%         if A.ndim == 2:
%             A = [A for i in range(T-1)]
% %                A = np.dstack([A for i in range(T-1)])
%         if C.ndim ==2:
%             C = [C for i in range(T-1)]
% %                C = np.dstack([C for i in range(T-1)])
%         if W.ndim == 2:
%             W = [W for i in range(T-1)]
% %                W = np.dstack([W for i in range(T-1)])
%         if not type(V)==np.ndarray: V = V * np.eye(obj.obsDim)
%         if V.ndim ==2:
%             V = [V for i in range(T-1)]
% %                V = np.dstack([V for i in range(T-1)])
%         P = [0]
%         K = [0]
%         X = [X0]
%         Q = [Q]
% 
% 
%         for t in range(1,T):
% 
%             % model state update
%             Xhat = np.dot(A[t-1], X[t-1])
%             % model covariance update
%             P.append(np.dot(np.dot(A[t-1], Q[t-1]), A[t-1].transpose()) + W[t-1])
%             % calculate Kalman gain
%             K.append(np.dot(np.dot(P[t], C[t-1].transpose()), np.linalg.linalg.pinv(np.dot(np.dot(C[t-1], P[t]), C[t-1].transpose()) + V[t-1])))
%             % use gain to correct state and covariance
%             X.append(Xhat + np.dot(K[t], Y[:,t] - np.dot(C[t-1], Xhat)))
%             Q.append(P[t] - np.dot(np.dot(K[t], C[t-1]), P[t]))

else

    % one time filter
    % model state prediction
    Xhat = obj.A * X0;
    % model covariance prediction
    P    = obj.A * Q * obj.A' + obj.W;
    % calculate Kalman gain
    K    = P * obj.C' * pinv(obj.C * P * obj.C' + V);
    % use gain to correct state and covariance
    X    = Xhat + K * (Y - obj.C * Xhat);
    Q    = P - K * obj.C * P;

end


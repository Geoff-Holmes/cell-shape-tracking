import numpy as np
import copy

class KalmanFilter:

    '''Create Kalman filter object

       Model:
        X(t+1) = AX(t) + w, w~N(0,W)
        Y(t)   = CX(t) + v, v~N(0,V)
        
       Other input / ouput:
        X is optimal posterior state estimate
        X(t) forms the input, X(t+1) is the output
        P is prior state covariance
        K is Kalman gain
        Q is latest posterior state covariance
        Q(t) forms the input, Q(t+1) is the output

       geoff.r.holmes@sheffield.ac.uk 28Feb13'''

    def __init__(self, A=None, C=None, W=None, V=None):
        self.A = A
        self.C = C
        self.W = W
        self.V = V

    def __call__(self, X0, Q, Y, A=None, C=None, W=None, V=None):
        '''parameters passed directly override the defaults
        '''

        if A == None: A = self.A
        if C == None: C = self.C
        if W == None: W = self.W
        if V == None: V = self.V
        
        self.stateDim = A.shape[0]
        self.obsDim   = C.shape[0]
 
        if Y.ndim > 1:
            # filer the whole sequence of observations
            T = Y.shape[1]
#            temp = X
#            X     =  np.array((T-1, self.stateDim))
#            X[0,] = temp
#            P     = np.zeros((T, self.stateDim, self.stateDim))
#            P[0,] = None * np.ones(Q.shape)
#            temp  = Q
#            Q     = np.zeros((T, self.stateDim, self.stateDim))
#            Q[0,] = temp
#            K     = np.zeros((T, self.stateDim, self.obsDim))

            if A.ndim == 2:
                A = [A for i in range(T-1)]
#                A = np.dstack([A for i in range(T-1)])
            if C.ndim ==2:
                C = [C for i in range(T-1)]
#                C = np.dstack([C for i in range(T-1)])
            if W.ndim == 2:
                W = [W for i in range(T-1)]
#                W = np.dstack([W for i in range(T-1)])
            if not type(V)==np.ndarray: V = V * np.eye(self.obsDim)
            if V.ndim ==2:
                V = [V for i in range(T-1)]
#                V = np.dstack([V for i in range(T-1)])
            P = [0]
            K = [0]
            X = [X0]
            Q = [Q]


            for t in range(1,T):

#                # model state update
#                Xhat = np.dot(A[:,:,t-1], X[:,t-1])
#                # model covariance update
#                P[:,:,t] = np.dot(np.dot(A[:,:,t-1], Q[:,:,t-1]), A[:,:,t-1].transpose()) + W[:,:,t-1]
#                # calculate Kalman gain
#                K[:,:,t]    = np.dot(np.dot(P[:,:,t], C[:,:,t-1].transpose()), np.linalg.linalg.pinv(np.dot(np.dot(C[:,:,t-1], P[:,:,t]), C[:,:,t-1].transpose()) + V[:,:,t-1]))
#                # use gain to correct state and covariance
#                X[:,t] = Xhat + np.dot(K[:,:,t], Y[:,t-1] - np.dot(C[:,:,t-1], Xhat))
#                Q[:,:,t]    = P[:,:,t] - np.dot(np.dot(K[:,:,t], C[:,:,t-1]), P[:,:,t])
                
                # model state update
                Xhat = np.dot(A[t-1], X[t-1])
                # model covariance update
                P.append(np.dot(np.dot(A[t-1], Q[t-1]), A[t-1].transpose()) + W[t-1])
                # calculate Kalman gain
                K.append(np.dot(np.dot(P[t], C[t-1].transpose()), np.linalg.linalg.pinv(np.dot(np.dot(C[t-1], P[t]), C[t-1].transpose()) + V[t-1])))
                # use gain to correct state and covariance
                X.append(Xhat + np.dot(K[t], Y[:,t] - np.dot(C[t-1], Xhat)))
                Q.append(P[t] - np.dot(np.dot(K[t], C[t-1]), P[t]))


        else:
            # one time filter
            # model state update
            Xhat = np.dot(A, X0)
            # model covariance update
            P    = np.dot(np.dot(A, Q), A.transpose()) + W
            # calculate Kalman gain
            K    = np.dot(np.dot(P, C.transpose()), np.linalg.linalg.pinv(np.dot(np.dot(C, P), C.transpose()) + V))
            # use gain to correct state and covariance
            X    = Xhat + np.dot(K, Y - np.dot(C, Xhat))
            Q    = P - np.dot(np.dot(K, C), P)

        return X, P, Q, K
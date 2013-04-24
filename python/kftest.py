import KalmanFilter as kf
import numpy as np

reload(kf)

A = np.array([[5,1], [2,2]])/10
C = np.array([[1,0],[0, 1]])
W = np.eye(2)
V = np.eye(2)/1

k = kf.KalmanFilter(A,C,W,V)

T = 20
Y = np.zeros((2,T))
X = np.zeros((2,T))

for t in range(1,T):

    X[:,t] = np.dot(A,X[:,t-1]) + np.random.normal(0,1,2)

    Y[:,t] = np.dot(C, X[:,t]) +  np.random.normal(0,1,2)

print X

X, P, Q, K = k(X[:,0], 10*np.eye(2), Y)

print X
X = np.array(X)
X = X.transpose()

print X
import pylab as pb
pb.close()
pb.ion()
pb.plot(X[1,])
pb.plot(Y[1,])


for t in range(1,T):

    X[:,t], P, Q, K = k(X[:,t-1], np.eye(2), Y[:,t])
pb.figure()
pb.plot(X[1,])
pb.plot(Y[1,])



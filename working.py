#!usr/bin/pthon

import numpy as np
import pylab as pb
import Basis, Bspline

knots = range(7)
N = len(knots)
B = Basis.Basis(knots)
s = np.linspace(0,N-1,100)
# Q = np.random.random((2,N-1))
Q = np.vstack((np.array([1, 1, 3, 4, 5, 3]), np.array([1, 6, 4, 6, 1, 3])))
shape = B(Q, s)
shape[:,-1] = shape[:,0]

pb.ion()
pb.plot(Q[0,:], Q[1,:], 'r+')
pb.plot(shape[0,:], shape[1,:])
pb.axis([0, 6, 0, 7])
pb.figure()
for b in B.Bsplines:
    pb.plot(b(s))

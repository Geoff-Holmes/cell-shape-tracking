import numpy as np
import Bases
import KalmanFilter

class Tracker :

    def __init__(self, BsplineNo, BsplineDim):

        self.Bspline = Bases.Base(L = BsplineNo, d = BsplineDim)
        A = np.eye(2*BsplineNo)
#        C = np.hstack((np.vstack((np.ones((BsplineNo,1)), np.zeros((BsplineNo,1)))), np.vstack((np.zeros((BsplineNo,1)), np.ones((BsplineNo, 1))))))
        self.KF = KalmanFilter.KalmanFilter(A, None, 10*np.eye(2*BsplineNo), 2)

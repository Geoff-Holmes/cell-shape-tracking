#!usr/bin/python

import numpy as np

class Bspline :

    def __init__(self, n):
        self.offset = n

    def __call__(self, s):
        s = float(s - self.offset)
        if s<0:
            B = 0
        elif s<1:
            B = np.power(s,2)/2
        elif s<2:
            B = .75 - np.power(s-1.5, 2)
        elif s<3:
            B = np.power(s-3,2)/2
        else:
            B = 0
        return B


class BsplineV :

    def __init__(self, n):
        self.offset = n

    def __call__(self, s):
        B = np.power(s,2)/2*np.vstack((0<=s, s<1)).all(0) + (.75-np.power(s-1.5,2))*np.vstack((1<=s, s<2)).all(0) + np.power(s-3,2)/2*np.vstack((2<=s, s<3)).all(0)
        return B

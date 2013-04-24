import numpy as np
import Bases

class simCell:
    '''simulate moving cell boundary using an Nb basis spline function'''
    def __init__(self, Nb=12, globalDrift=0):
        self.Nb = Nb
        self.globalDrift = globalDrift
        # create basis
        self.B = Bases.Base(self.Nb)
        #initialise shape via complex control points
        Ctrl = np.exp(2*np.pi*1j*np.array(range(self.Nb))/self.Nb)
        self.B(Ctrl, plt=1)
        Bases.pb.axis([-10,10,-10,10])
        for i in range(100): 
            Ctrl += 0.4*np.random.normal(0,1,self.Nb) + self.globalDrift*np.ones((self.Nb))
            self.globalDrift += 0.1*np.dot(np.array([1,1j], dtype=complex), np.random.normal(0,1,2))
            self.B(Ctrl, plt=1)


        


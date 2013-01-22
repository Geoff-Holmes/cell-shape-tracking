#!usr/bin/python

import numpy as np

class Base :
    # periodic spline function defined on the parameter range [0, L]
    # i.e. L+1 breakpoints, L indep knot multiplities since mL = m0
    # breakpoints regular unit intervals unless specified otherwise
    # the spline has order d, i.e. each basis function has d spans
    def __init__(self, L, kntMults=1, brkPts=1, d=3):
        # ensure consistency
        if kntMults == 1:
            kntMults = [1 for i in range(L+1)]
        else:
            assert len(kntMults) == L+1
        if brkPts ==1 :
            brkPts = range(L+1)
        else:
            assert len(brkPts) == L+1
        # condition for periodic spline:
        assert kntMults[0] == kntMults[-1]
        #
        self.L = L
        self.s = np.linspace(0, L, 100)
        self.brkPts = brkPts
        self.kntMults = kntMults
        self.d = d
        # number of basis functions
        self.Nb = sum(self.kntMults[1:])
        #
        # calculate knot values
        self.knots = []
        p = 0; q = 0
        for i in range(self.L):
            for j in range(0, kntMults[i]):
                self.knots.append(brkPts[q])
                p += 1
            q += 1
        self.knots.append(brkPts[-1]) # not sure if this line should be here???
        # make periodic referencing easier
        self.knots += [self.knots[-1] + item for item in self.knots[1:]]
        #
        # initialise for calc of spline matrices via Blake App.A p291
        # extra column a copy of first to make calculation easier
        self.B = np.zeros((d, d, L, self.Nb+1))  # iteration, coefficients of power, spans, basis functions
        # d=1
        for i in range(self.Nb):
            self.B[0,0,:,i][np.array(self.brkPts[:-1]) == self.knots[i]] = 1
            self.B[0,0,:,-1] = self.B[0,0,:,0]#
        #
        for di in range(2,self.d+1): # looping over remaining dimensions
            for n in range(self.Nb): # looping over basis functions
                denom1 = self.knots[n+di-1] - self.knots[n]
                denom2 = self.knots[n+di] - self.knots[n+1]
                print 'denoms', denom1, denom2
                for sig in range(self.L): # looping over spans
                    # terms are zero if denominators are zero
                    if denom1:
                        const1  = float((sig - self.knots[n])%self.L)/denom1
                        const1s = 1.0/denom1
                    else:
                        const1  = 0
                        const1s = 0
                    if denom2:
                        const2  = float((self.knots[n+di] - sig)%self.L)/denom2
                        const2s = 1.0/denom2
                    else:
                        const2  = 0
                        const2s = 0
                    print const1,'*',self.B[(di-1)-1, :, sig, n  ], const1s,'*',self.B[(di-1)-1, :-1, sig, n], const2,'*',self.B[(di-1)-1, :, sig, n+1], -const2s,'*',self.B[(di-1)-1, :-1, sig, n+1]  
                    # constant times existing power of s coefficients
                    # nb for referencing di-1 is used since di runs from (1)2-self.d
                    self.B[di-1, :, sig, n] = ( const1 * self.B[(di-1)-1, :, sig, n  ] + 
                                         const2 * self.B[(di-1)-1, :, sig, n+1]) 
                    # unit (s) times one lower power
                    self.B[di-1, 1:, sig, n] += const1s * self.B[(di-1)-1, :-1, sig, n] - const2s * self.B[(di-1)-1, :-1, sig, n+1]
            self.B[di-1,:,:,-1] = self.B[di-1,:,:,0]
        # remove final duplicate column now no longer needed
        self.B = self.B[:,:,:,:-1]
        #
        # initialise span matrices
        self.bsig = []
        self.BS = np.zeros((self.L, self.d, self.d))
        for sig in range(self.L): # loop over each span
            # find first basis function which this span supports
            self.bsig.append(sum(self.kntMults[:sig+1]) - self.d)
        # for periodic referencing
        self.bsig += self.bsig
        for sig in range(self.L): # loop over each span
            # store span matrix
            #print self.bsig, self.bsig[sig:sig+self.d]
            self.BS[sig, :, :] = self.B[-1, :, sig, self.bsig[sig:sig+self.d]].transpose()
            #print self.BS[sig, :, :]
#
    def __call__(self, ctrlPts0, s=-1):
        # evaluate spline function with its bases weighted by the control points 
        assert len(ctrlPts0) == self.Nb #ctrlPts0.shape == (2,self.Nb) # one control point for each basis
        ctrlPts = 2*ctrlPts0
        # (1,s,s^2,...)BS(sig)x
        # find which span is needed
        sig = np.where(np.array(self.brkPts) > s)[0][0]-1 # - self.L #not needed if ctrlPts made periodic as above
        s = s - sig
        svec = np.array([np.power(s,i) for i in range(self.d)])
        #print svec; print self.BS[sig,:,:]; 
        #print np.array(ctrlPts)[range(sig,sig+self.d)]
        F = np.dot(np.dot(svec, self.BS[sig,:,:]), np.array(ctrlPts)[self.bsig[sig:sig+self.d]])
        return F

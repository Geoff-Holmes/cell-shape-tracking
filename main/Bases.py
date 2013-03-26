#:!usr/bin/python     ################# check %self.L  should it be @=%self.Nb etc ?????

# breaks down for multiple knots when d>3
# breaks down when d = 10  presumably need further copies of self.knots or something

import numpy as np
import pylab as pb
import itertools as it
import copy

class Base :
    # periodic spline function defined on the parameter range [0, L]
    # breakpoints regular unit intervals unless specified otherwise
    # the spline has order d, i.e. each basis function has d spans
    def __init__(self, L, kntMults=1, brkPts=1, d=3, prdc=1, NtestPts=1000):
        assert d < 13
        self.d = d
        self.prdc = prdc
        # ensure consistency
        if brkPts ==1 :
            brkPts = range(L+1)
        else:
            assert brkPts[-1] == L
            assert brkPts[0] == 0
        self.brkPts = brkPts
        self.L = L
        self.Nbrk = len(self.brkPts)
        self.s = np.linspace(0, brkPts[-1], NtestPts)
        if kntMults == 1:
            if prdc:
                self.kntMults = [1 for i in range(self.Nbrk)]
            else:
                self.kntMults = [self.d]+[1 for i in range(self.Nbrk-2)]+[self.d]
        else:
            assert len(kntMults) == self.Nbrk
            self.kntMults = kntMults
        if self.prdc:
            assert self.kntMults[0] == self.kntMults[-1]
            # number of basis functions
            self.Nb = sum(self.kntMults[1:])
        else:
            try:
                assert self.kntMults[0] >= self.d
                assert self.kntMults[-1] >= self.d
            except AssertionError:
                print 'WARNING: If first and / or last knot multiples are less than d',
                print 'the end points of the spline cannot be fully controlled.'
            self.Nb = sum(self.kntMults) - d
        #rint 'Nb', self.Nb
        #
        # calculate knot values
        self.knots = []
        p = 0; q = 0
        for i in range(self.Nbrk):
            for j in range(0, self.kntMults[i]):
                self.knots.append(brkPts[q])
                p += 1
            q += 1
        if self.prdc:
            # make periodic referencing easier
            Nknots = len(self.knots)
            self.knots += [self.knots[-1] + item for item in self.knots[1:]]
            while len(self.knots) < 2* self.d:
                self.knots += [self.knots[-1] + item for item in self.knots[1:]]
            #rint self.knots
            
            #
        # initialise for calc of spline matrices via Blake App.A p291
        # iteration, coefficients of power, spans, basis functions
        # extra column a copy of first to make calculation easier
        self.B = np.zeros((d, d, L, self.Nb+1))  
        # d=1
        for i in range(self.Nb):
            self.B[0,0,:,i][np.array(self.brkPts[:-1]) == self.knots[i]] = 1
            if self.prdc:
                self.B[0,0,:,-1] = self.B[0,0,:,0]
        #
        for di in range(2,self.d+1): # looping over remaining dimensions
            for n in range(self.Nb): # looping over basis functions
                #rint n,di, self.knots
                denom1 = self.knots[n+di-1] - self.knots[n]
                denom2 = self.knots[n+di] - self.knots[n+1]
                #rint 'denoms', denom1, denom2
                for sig in range(self.Nbrk-1): # looping over spans
                    # terms are zero if denominators are zero
                    if denom1:
                        const1  = float((self.brkPts[sig] - self.knots[n])%self.L)/denom1
                        const1s = 1.0/denom1
                    else:
                        const1  = 0
                        const1s = 0
                    if denom2:
                        const2  = float((self.knots[n+di] - self.brkPts[sig])%self.L)/denom2
                        const2s = 1.0/denom2
                    else:
                        const2  = 0
                        const2s = 0
                    #
                    #rint const1,'*',self.B[(di-1)-1, :, sig, n  ], const1s,'*',self.B[(di-1)-1, :-1, sig, n], \ 
                    #const2,'*',self.B[(di-1)-1, :, sig, n+1], -const2s,'*',self.B[(di-1)-1, :-1, sig, n+1]  
                    #
                    # constant times existing power of s coefficients
                    # nb for referencing di-1 is used since di runs from (1)2-self.d
                    self.B[di-1, :, sig, n] = ( const1 * self.B[(di-1)-1, :, sig, n  ] + 
                                         const2 * self.B[(di-1)-1, :, sig, n+1]) 
                    # unit (s) times one lower power
                    self.B[di-1, 1:, sig, n] += ( const1s * self.B[(di-1)-1, :-1, sig, n]  - 
                                                  const2s * self.B[(di-1)-1, :-1, sig, n+1] )
            if self.prdc:
                self.B[di-1,:,:,-1] = self.B[di-1,:,:,0]
        # remove final duplicate column now no longer needed
        self.B = self.B[:,:,:,:-1]
        #rint self.B[-1,:,:,:]
        #
        # initialise span matrices
        self.bsig = []
        self.BS = np.zeros((self.Nbrk-1, self.d, self.d))
        for sig in range(self.Nbrk): # loop over each span
            # find first basis function which this span supports
            self.bsig.append(sum(self.kntMults[:sig+1]) - self.d)
#        if self.prdc:
#            # for periodic referencing
#            self.bsig += self.bsig
        for sig in range(self.Nbrk-1): # loop over each span
            # store span matrix
            #rint self.bsig, self.bsig[sig:sig+self.d]
            #rint self.bsig, sig
            #rint self.B[-1, :, sig,:]
            #rint self.B[-1, :, sig, self.bsig[sig]:self.bsig[sig]+self.d]
            bRange = np.array(range(self.bsig[sig], self.bsig[sig]+self.d))
            #rint bRange
            if prdc:
                bRange = bRange%self.Nb
            #rint bRange
            self.BS[sig, :, :] = self.B[-1, :, sig, bRange].transpose()
            #rint self.BS[sig, :, :]
        #
        if self.prdc:
            # remove temporary duplicates
            self.knots = self.knots[:Nknots]
        #
        # check normality
        test = self.__call__(np.ones(self.Nb))
        assert float(test.min()) > 0.99999 and float(test.max()) < 1.00001 

        # make placement matrices
        self.G = np.zeros((self.Nb, self.d, self.Nb))
        for k in range(self.Nb):
            for i in range(self.d):
                # row i picks up bsig+ith control point
                j = self.bsig[k]+i
                if j > self.Nb:
                    j -= self.Nb
                self.G[k,i,j] = 1

    def makeMetric(self):
        '''Construct basis metric matrix'''
        # initialise matrix
        self.metric = np.zeros((self.Nb, self.Nb))
        # get span matrix row / column indicies
        inds = range(self.d)
        # loop over all span matrices
        for k in range(self.Nbrk-1):
            print self.BS[k] # span matrix
            # initialise storage for contributions to integrals from this span
            bases = np.array(range(self.bsig[k],self.bsig[k]+self.d)) % self.Nb
            print bases
            # get all index pairs
            indPairs = it.combinations_with_replacement(inds, 2)
            while 1:
                try:
                    pair = indPairs.next()
                except StopIteration:
                    break
                print pair
                # meshgrid of respective coefficients of powers of s
                X,Y = np.meshgrid(self.BS[k][:,pair[0]], self.BS[k][:,pair[1]])
                #rint X
                #rint Y
                # get product coefficients
                Z= X * Y
                # prepare to add up coefficients of same powers of s
                Z = Z[::-1]
                scoeff = []
                # add up coeffs
                for j in range(-self.d+1,self.d):
                    scoeff.append(Z.trace(j, dtype=float))
                #rint Z
                #rint scoeff
                # get powers of s
                pwr = np.array(range(1,2*self.d))
                # ingetrate
                intComp = (np.array(scoeff)/pwr*np.power(np.array(self.brkPts[k+1])-
                        np.array(self.brkPts[k]),pwr)).sum()
                print 'intComp', intComp
                # add to appropriate entry in metric matrix
                self.metric[bases[pair[0]], bases[pair[1]]] += intComp
        # fill in empty symmetric entries
        self.metric = self.metric + self.metric.transpose() - np.diag(self.metric.diagonal())
        # normalise
        self.metric /= self.L
        return self.metric
#
    def __call__(self, ctrlPts0, s=-1, plt=0):
        # evaluate spline function with its bases weighted by the control points 
        # (1,s,s^2,...)BS(sig)x
        assert len(ctrlPts0) == self.Nb # one control point for each basis
        ctrlPts = copy.deepcopy(ctrlPts0)
#        if self.prdc: #            # for periodic ease
#            ctrlPts = 2*ctrlPts0
        ctrlPts = np.array(ctrlPts)
        ctrlPts.astype(complex)
        if s >= 0:
            # find which span is needed
            sig = np.where(np.array(self.brkPts) > s)[0][0]-1 
            # for calculation s runs from 0 in each span
            s = s - self.brkPts[sig]
            # get all the powers of s
            svec = np.power(s * np.ones(self.d), np.array(range(self.d)))
            #print svec; print self.BS[sig,:,:]; 
            #print np.array(ctrlPts)[range(sig,sig+self.d)]
            bRange = np.array(range(self.bsig[sig], self.bsig[sig]+self.d))%self.Nb
            F = np.dot(np.dot(svec, self.BS[sig,:,:]), ctrlPts[bRange])
        else:
            F = np.array(())
            for sig in range(len(self.brkPts[:-1])):
                sigL = self.brkPts[sig]
                #print self.s, np.vstack((self.s>=sigL, self.s<self.brkPts[sig+1])).all(0)
                #print self.s[np.vstack((self.s>=sigL, self.s<self.brkPts[sig+1])).all(0)]
                sSig = self.s[np.vstack((self.s>=sigL, self.s<self.brkPts[sig+1])).all(0)]-sigL
                #rint 'sSig', sSig
                svec = np.array([np.power(sSig,j) for j in range(self.d)])
                #rint 'svec', svec
                bRange = np.array(range(self.bsig[sig], self.bsig[sig]+self.d))%self.Nb
                temp = np.dot(np.dot(svec.transpose(), self.BS[sig,:,:]), 
                              np.array(ctrlPts)[bRange])
                F = np.hstack((F, temp))
            if self.prdc:
                # close the shape
                F = np.hstack((F, F[0]))
            else:
                # don't close the shape - may cause slight problem if sample points are few
                F = np.hstack((F,F[-1]))
        if plt:
            pb.plot(F.real, F.imag)
        return F

    def showBasis(self):
        '''Plots all basis functions.  Also plot their sum to verify normalisation at each point.'''
        ctrlPts = np.vstack((np.eye(self.Nb), np.ones(self.Nb)))
        pb.figure()
        pb.title('Spline function basis')
        labels = []
        for i in range(self.Nb+1):
            pb.plot(self.s, self.__call__(ctrlPts[i]))
            labels.append('Basis ' + str(i))
        labels[-1] = 'summation'
        pb.legend(labels)
        pb.ylim([0,1.1])

    def dataFit(self, data, plt=0):
        '''Determine control points to fit spline function to inputted data.'''
        nData = len(data)
        # divide up path parameter
        sData = np.linspace(0, self.L, num=nData+1)[:-1]
        # initialise least squares design matrix
        DsnMat = np.zeros((nData, self.Nb))
        # populate design matrix
        for i in range(nData):
            # find which span is needed
            sig = pb.find(sData[i]>=np.array(self.brkPts))[-1]
            DsnMat[i,] = np.dot(np.power(sData[i]-self.brkPts[sig],range(self.d)), np.dot(self.BS[sig,], self.G[sig,]))
        # get control points via least squares
        Ctrl = np.dot(np.linalg.pinv(np.dot(DsnMat.transpose(), DsnMat)), np.dot(DsnMat.transpose(), data))
        if plt:
            pb.figure()
            pb.plot(data.real, data.imag, '.')
            fittedCurve = self.__call__(Ctrl)
            pb.plot(fittedCurve.real, fittedCurve.imag)
            pb.plot(Ctrl.real, Ctrl.imag, 'r+')
        return Ctrl

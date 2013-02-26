#!usr/bin/python
def go():
    import numpy as np
    import pylab as pb

    pb.ion()

    import Bases
    reload(Bases)

    # create bSpline
    L = 5
    B = Bases.Base(L,prdc=1)

    print B.G
    print B.BS

    # create data
    Ndata = 100
    R = 100
    r = R
    e = 0

    data = np.zeros(Ndata, dtype=complex)
    for i in range(Ndata):
        data[i] = r * np.exp(np.pi+2*np.pi*1j*i/Ndata)
        r = r - 0.1*(r-R) + e
        #e += np.random.normal(0,1)

    # fit bSpline
    ctrlPts = B.dataFit(data)
    fittedSpline = B(ctrlPts)
    pb.figure()
    pb.plot(fittedSpline.real, fittedSpline.imag)
    pb.plot(data.real, data.imag, '.')
    pb.plot(ctrlPts.real, ctrlPts.imag, 'r+')

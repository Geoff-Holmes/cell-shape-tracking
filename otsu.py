import numpy as np

def otsu(data, divisions=10):
    '''get otsu threshold level'''
    bars, edges = np.histogram(data, divisions)
    # divisions can be a scalar or vector of bin edges
    if not type(divisions)==int: divisions = len(divisions)-1
    #rint "edges", edges
    #rint "bars", bars
    probs = np.array(bars, dtype=float)/data.size
    #rint "probabilities", probs
    barwidth = edges[1] - edges[0]
    centres = edges[:-1] + barwidth/2
    # initialise weights and means
    w1  = np.zeros(divisions)
    mu1 = np.zeros(divisions)
    w2  = np.zeros(divisions)
    mu2 = np.zeros(divisions)
    sigb = np.zeros(divisions)

    #rint "centres", centres

    w2[0]  = probs.sum()
    mu2[0] = (probs * centres).sum()
    #rint '\n', 0
    #rint 'mean1', mu1[0]
    #rint 'w1', w1[0]
    #rint 'mean2', mu2[0]
    #rint 'w2', w2[0]
    #rint 'sigb', sigb[0]

    denom1 = 0
    denom2 = bars.sum()

    for t in range(1,divisions):
        #rint '\n'
        #rint t
        w1[t] = w1[t-1] + probs[t-1]
        w2[t] = w2[t-1] - probs[t-1]

        change = bars[t-1] * centres[t-1]
        
        temp = mu1[t-1] * denom1 + bars[t-1]*centres[t-1]
        denom1 += bars[t-1]
        mu1[t] = temp / denom1
        temp = mu2[t-1] * denom2 - bars[t-1]*centres[t-1]
        denom2 -= bars[t-1]
        mu2[t] = temp / denom2

        sigb[t] = w1[t]*w2[t]*np.power(mu1[t]-mu2[t], 2)
        #rint 'mean1', mu1[t]
        #rint 'w1', w1[t]
        #rint 'mean2', mu2[t]
        #rint 'w2', w2[t]
        #rint 'sigb', sigb[t]

    #rint '\n', 'threshold', sigb.argmax()
    return centres[sigb.argmax()]

if __name__ == "__main__":
    # verify using data shown on http://www.labbookpages.co.uk/software/imgProc/otsuThreshold.html
    data = np.array([0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,5,5,5,5]) # np.random.random(100)
    threshold = otsu(data, np.arange(-.5,6.5))
    print 'Otsu threshold is ', threshold

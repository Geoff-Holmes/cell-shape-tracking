#!usr/bin/python     ################# check %self.L  should it be @=%self.Nb etc ?????

class splineCurve :
    def __init__(self, Basis=10, dim=2):
        self.dim = dim
        if type(Basis) == int:
            Basis = Base(Basis)
            self.Bases = [Basis for i in range(self.dim)] 
        elif isinstance(Basis, Base) and Basis.__module__ == 'makePolys':
            self.Bases = [Basis for i in range(self.dim)]
        elif type(Basis) == list and isinstance(Basis[0], Base) and Basis[0].__module__ == 'makePolys':
            assert len(Basis) == self.dim
            self.Bases = Basis
        else:
            print 'Invalid basis'

    def __call__(self, ctrlPts, s=-1, plt=1, pltCtrl=0):
        assert ctrlPts.shape[1] == self.dim
        ctrlPts = ctrlPts.transpose()
        if s == -1:
            curve = np.zeros((self.dim, self.Bases[0].s.size))
        else:
            curve = np.zeros(self.dim)
        for i in range(ctrlPts.shape[0]):
            curve[i] = self.Bases[i](ctrlPts[i], s)
        if plt:
            pb.plot(curve[0], curve[1])
        if pltCtrl:
            pb.plot(ctrlPts[0], ctrlPts[1], 'r+')
        return curve


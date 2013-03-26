import otsu
import os
import pylab as pb
import numpy as np
import Image
import pylab as pb
import glob

def readTIFF16(path, plt=0):
    """Read 16bits TIFF"""
    im = Image.open(path)
    out = np.fromstring(
        im.tostring(), 
        np.uint16
        ).reshape(tuple(list(im.size)))
    out = out.max() - out
    if plt:
        pb.imshow(out, cmap='Greys')
    return out


def getChannel(chnl, plt=0):
    '''Get all z-slices for a channel at one timeframe'''
    fls = glob.glob('*C0'+str(chnl)+'*.tif')
    print fls
    imList = []
    for i in range(len(fls)):
        print i,fls[i]
        if plt: pb.subplot(3,3,i+1)
        imList.append(readTIFF16(fls[i], plt=(plt==1)))
    return imList


if __name__== "__main__":

    pb.ion()
    os.chdir('images/T00001')
    imList = getChannel(2, plt=1)
    os.chdir('../..')
    bwList = []
    thresh  = []
    j = 1
    figs = []
    figs.append(pb.figure())
    figs.append(pb.figure())
    figs.append(pb.figure())
    for im in imList:
        thresh.append(otsu.otsu(im))
        bwList.append(im>=thresh[-1])
        pb.figure(figs[0].number)
        pb.subplot(3,3,j)
        pb.imshow(bwList[-1])
        pb.figure(figs[1].number)
        pb.subplot(3,3,j)
        temp = im
        ind = temp==0
        temp[ind] = temp.max()
        temp[ind] = temp.min()
        pb.hist(temp.reshape(temp.size), 100)
        pb.title('threshold '+ str(thresh[j-2]))
        pb.figure(figs[2].number)
        pb.subplot(3,3,j)
        pb.imshow(temp)
        j +=1
        


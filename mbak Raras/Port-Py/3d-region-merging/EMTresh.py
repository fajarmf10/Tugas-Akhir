import numpy as np
from scipy.ndimage.interpolation import shift

'''
    Expectation Maximization image segmentation
    Author: Prof. Jose Vicente Manjon Herrera
    Email: jmanjon@fis.upv.es
    Date: 02-05-2006
    Ported to Python 3 by Fajar Maulana Firdaus

    Input :
        ima: grey color image
        k: Number of classes

    Output :
        mask: clasification image mask
        mu: vector of class means
        v: vector of class variances
        p: vector of class proportions

'''


def histogram(datos):
    datos = datos.flatten('F')
    ind = np.where(np.isnan(datos))
    datos[ind] = 0
    ind = np.where(np.isinf(datos))
    datos[ind] = 0
    tam = datos.size
    m = np.ceil(np.max(datos)+1).astype(int)
    # because i start from 1
    h = np.zeros(m+1)
    for i in range(0, tam):
        f = np.floor(datos[i]).astype(int)
        if(f>0 and f<(m-1)):
            a2 = datos[i] - f
            a1 = 1 - a2
            h[f] = h[f] + a1
            h[f + 1] = h[f + 1] + a2
    # delete first element
    h = np.delete(h, 0)
    # checking
    # np.savetxt("notprocessed.csv", h, fmt='%i', delimiter=",")
    h = np.convolve(h, [1,2,3,2,1])
    # np.savetxt("convolved.csv", h, fmt='%i', delimiter=",")
    h = h[3:len(h)-2]
    # np.savetxt("len.csv", h, fmt='%i', delimiter=",")
    # Result of sum is different than the matlab version
    h = h/np.sum(h)
    # np.savetxt("sum.csv", h, delimiter=",")
    return h


def em_tresh(ima, k):
    # Initialize new variable to host from ima value
    new_ima = np.zeros((266,266,1), dtype=int)
    # print(ima[120][168])
    for i in range(len(ima)): # Loop 266x
        for j in range(len(ima[i])): #Loop 266x
            # print(ima[i][j][0])
            new_ima[i][j][0] = ima[i][j][0]
    copy = new_ima.copy()
    ima = new_ima.flatten('F').astype(int)
    # print(ima.size)
    # np.savetxt("aaa.csv", ima, fmt='%i', delimiter=",")
    mi = np.min(ima).astype(int)
    ima = ima - mi + 1
    # m = int
    m = np.max(ima).astype(int)
    s = ima.size
    h = histogram(ima)
    # print('a')



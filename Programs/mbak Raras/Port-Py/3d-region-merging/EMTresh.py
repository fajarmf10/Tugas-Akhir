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

def distribution(m, v, g, x):
    #check instance
    if isinstance(m, np.ndarray):
        # x = x.transpose()
        # m = m.transpose()
        # v = v.transpose()
        # g = g.transpose()
        # Initialize variable y
        y = np.zeros((x.size, m.size))
        for i in range(np.size(m)):
            d = x - m[i]
            # np.savetxt("alala.csv", d, delimiter=",")
            amp = g[i] / np.sqrt(2 * np.pi * v[i])
            # ans = amp*np.exp(-0,5 * (np.multiply(d, d))/v[i])
            y[:, i] = np.dot(amp, np.exp(np.dot(- 0.5, (np.multiply(d, d))) / v[i]))
    else:
        sizem = m.size
        for i in range(m.size):
            d = x-m
            amp = g/np.sqrt(2 * np.pi * v)
            y = np.dot(amp, np.exp(np.dot(- 0.5, (np.multiply(d, d))) / v))
    # No need to transpose
    # x = x.transpose()
    # m = m.transpose()
    # v = v.transpose()
    # g = g.transpose()
    # # Initialize variable y
    # y = np.zeros((x.size, m.size))
    # for i in range(np.size(m)):
    #     d = x - m[i]
    #     # np.savetxt("alala.csv", d, delimiter=",")
    #     amp = g[i]/np.sqrt(2*np.pi*v[i])
    #     ans = np.dot(amp,np.exp(np.dot(- 0.5,(np.multiply(d,d))) / v[i]))
    #     # ans = amp*np.exp(-0,5 * (np.multiply(d, d))/v[i])
    #     y[:,i] = ans
    # # np.savetxt("distribution.csv", y, delimiter=",")
    return(y)


def find(arr, cond):
    # Implemented find function from Matlab
    if(isinstance(arr, np.ndarray)):
        return [i for (i, val) in np.ndenumerate(arr) if cond(val)]
    return [i for (i, val) in enumerate(arr) if cond(val)]


def find2(arr, cond):
    a = np.max(arr)
    return np.where(arr == a)
    # for(i, val) in np.ndenumerate(arr):



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
    h = h[2:len(h)-2]
    # np.savetxt("len.csv", h, fmt='%i', delimiter=",")
    # Result of sum is different than the matlab version
    h = h/np.sum(h)
    # np.savetxt("sum.csv", h, delimiter=",")
    return(h)


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
    x = find(h, lambda x: x>0)
    # np.savetxt("find.csv", x, fmt='%i', delimiter=",")
    h = h[x]
    # np.savetxt("change.csv", h, delimiter=",")
    x = np.transpose(x) + 1
    h = np.transpose(h)
    mu = np.dot(np.arange(1, k+1), m) / (k+1)
    v = np.dot(np.ones(k), m)
    p = np.dot(np.ones(k), 1) / k

    sml = np.mean(np.diff(x))/1000
    # print("SML : ", sml)
    #Begin EM Algorithm
    while(1):
        # Expectation
        prb = distribution(mu, v, p, x)
        scal = np.sum(prb, 1) + np.spacing(1)
        # np.savetxt("scal.csv", scal, delimiter=",")
        loglik = np.sum(np.multiply(h, np.log(scal)))
        # print(loglik)
        # loglik = np.sum(h*(np.log(scal)))

        # Maximization
        for j in range(k):
            pp = np.multiply(h, prb[:, j]) / scal
            # np.savetxt("pp.csv", pp, delimiter=",")
            p[j] = np.sum(pp)
            mu[j] = np.sum(np.multiply(x, pp)) / p[j]
            # print(mu[j])
            vr = (x-mu[j])
            # np.savetxt("vr.csv", vr, delimiter=",")
            v[j] = np.sum(np.multiply(np.multiply(vr, vr), pp)) / p[j] + sml
            # print(v[j])
        p = p + 0.001
        p = p / np.sum(p)

        # Exit condition
        prb = distribution(mu, v, p, x)
        scal = np.sum(prb, 1) + np.spacing(1)
        nloglik = np.sum(np.multiply(h, np.log(scal)))

        if(nloglik-loglik) < 0.0001:
            break

    mu = mu + mi - 1
    s = np.shape(x)[1]
    mask = np.zeros(s)

    hist_class = np.zeros(s)
    for i in range(s):
        c = np.zeros(k)
        for n in range(k):
            c[n] = distribution(mu[n], v[n], p[n], x[0][i])
        a = np.where(c == np.max(c))
        # print(a[0])
        # print(a[0][0])
        hist_class[i] = a[0][0]
    np.savetxt("histclass.csv", hist_class, delimiter=",")

    borders = np.zeros((k-1,1))
    for i in range(1, hist_class.size):
        if(hist_class[i-1] < hist_class[i]):
            # print(hist_class[i-1])
            borders[hist_class[i-1].astype(int)] = i-1
        # print(i)
    borders = borders+1
    # print("AAAAAA")
    return(borders, mu, v, p)
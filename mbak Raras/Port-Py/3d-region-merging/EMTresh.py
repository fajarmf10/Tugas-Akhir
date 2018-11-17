import numpy as np

'''
    Ported from Expectation Maximization image segmentation
    Author: Prof. Jose Vicente Manjon Herrera
    Email: jmanjon@fis.upv.es
    Date: 02-05-2006

    Input :
        ima: grey color image
        k: Number of classes

    Output :
        mask: clasification image mask
        mu: vector of class means
        v: vector of class variances
        p: vector of class proportions

'''

def em_tresh(ima, k):
    # Initialize new variable to host from ima value
    new_ima = np.zeros((266,266,1), dtype=int)
    print(ima[120][168])
    for i in range(len(ima)): # Loop 266x
        for j in range(len(ima[i])): #Loop 266x
            # print(ima[i][j][0])
            new_ima[i][j][0] = ima[i][j][0]
    copy = new_ima.copy()
    ima = new_ima.flatten('F').astype(int)
    print(ima.size)
    np.savetxt("aaa.csv", ima, fmt='%i', delimiter=",")
    mi = np.amin(ima).astype(int)
    ima = ima - mi + 1
    # m = int
    m = np.amax(ima).astype(int)
    s = ima.size
    print('a')



import cv2 as cv
from matplotlib import pyplot as plt
import numpy as np, time
from EMTresh import em_tresh

def tic():
    import time
    global startTime_for_tictoc
    startTime_for_tictoc = time.time()

def toc():
    if 'startTime_for_tictoc' in globals():
        print("Elapsed time is " + str(time.time() - startTime_for_tictoc) + " seconds.")
    else:
        print("Toc: start time not set")


def srm3d(I, Q, dim):
    if len(locals()) <= 2:
        dim = 2
    if len(locals()) == 1:
        Q = 256
    smallest_region_allowed = 1
    size_image = list(I.shape[:2])


def thresholding(img):
    k, num_bins = 4, 256
    hist = cv.calcHist([img], [0], None, [256], [0, 256])
    hist = np.transpose(hist).astype(int)
    borders, mu, v, p = em_tresh(img, k)
    t = borders[3]/256
    return t


if __name__ == '__main__':
    datadir = "../Data/"
    name = "1_Bpk_Setyo"
    input_dir = datadir + name + "/axial/"

    start = 1
    num = 200
    levels = 256

    '''
        2D Region Merging
    '''
    for i in range(1, levels):
        Q = i
        t2d = []
        for j in range(start, num):
            path = input_dir + str(j) + ".bmp"
            img = cv.imread(path)
            # print(type(img))
            t2d[j-start+1] = thresholding(img)
            imreg2 = srm3d(img.astype(float), Q, 2)
            print("A")


import cv2 as cv
from matplotlib import pyplot as plt
import numpy as np, time
from EMTresh import em_tresh
from srm3d import srm3d

def tic():
    import time
    global startTime_for_tictoc
    startTime_for_tictoc = time.time()

def toc():
    if 'startTime_for_tictoc' in globals():
        print("Elapsed time is " + str(time.time() - startTime_for_tictoc) + " seconds.")
    else:
        print("Toc: start time not set")


def thresholding(img):
    k, num_bins = 4, 256
    hist = cv.calcHist([img], [0], None, [256], [0, 256])
    hist = np.transpose(hist).astype(int)
    borders, mu, v, p = em_tresh(img, k)
    t = borders[2]/256
    return t


if __name__ == '__main__':
    datadir = "../Data/"
    name = "3_Nn_Kartika_Afrida_Fauzia"
    input_dir = datadir + name + "/axial/"

    start = 1
    num = 200
    levels = 256

    '''
        2D Region Merging
    '''
    for i in range(1, levels):
        Q = i
        t2d = np.zeros((200,1))
        for j in range(start, num):
            path = input_dir + str(j) + ".bmp"
            img = cv.imread(path)
            # print(type(img))
            t2d[j-1] = thresholding(img)
            imreg2 = srm3d(img.astype(float), Q, 2)
            print("A")


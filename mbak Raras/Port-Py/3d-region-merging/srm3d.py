import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt

def srm3d(I, Q, dim):
    if len(locals()) <= 2:
        dim = 2
    if len(locals()) == 1:
        Q = 256
    smallest_region_allowed = 1
    size_image = [np.shape(I)[0], np.shape(I)[1]]
    if(dim==2):
        [Ix, Iy] = [cv.Sobel(I, cv.CV_64F,1,0), cv.Sobel(I, cv.CV_64F,0,1)]
        normgradient = np.sqrt(Ix ** 2.0 + Iy ** 2.0)
        # Ixx = plt.imshow(Ix)
        # plt.show()
        # Iyy = plt.imshow(Iy)
        # plt.show()
        Ix = np.delete(Ix, 0, -1)
        Iy = np.delete(Iy, -1, 0)
        # BADDDDDDD MOODDDDDD
        index = np.append(np.abs(Iy.flatten(1)), np.abs(Ix.flatten(1)))
        # index = np.abs([Iy.flatten(1)])
        # index = np.append(index, )

        # index = np.sort(np.abs([Iy.flatten(1); Ix.flatten(1)]))
    print('A')

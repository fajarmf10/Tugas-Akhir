import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt


if __name__=='__main__':
    img = cv.imread('../../Datasets/Bitewing/1.jpg', cv.COLOR_BGR2GRAY)
    # Resizing image
    img = cv.resize(img, (0,0), fx=0.4, fy=0.4)
    # Equalizing Hist
    equ = cv.equalizeHist(img)
    # CLAHE
    clahe = cv.createCLAHE()
    cl1 = clahe.apply(equ)

    # Binarizing image using Otsu's Tresholding
    ret2, th2 = cv.threshold(cl1, 0, 255, cv.THRESH_BINARY + cv.THRESH_OTSU)

    plt.imshow(th2, cmap='gray')
    plt.show()
    # cv.waitKey()
    # cv.destroyAllWindows()
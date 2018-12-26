import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt


def plot_hist(images, cols=1, titles=None):
    n_images = len(images)
    if titles is None: titles = ['Image (%d)' % i for i in range(1, n_images + 1)]
    fig = plt.figure()
    for n, (image, title) in enumerate(zip(images, titles)):
        a = fig.add_subplot(cols, np.ceil(n_images / float(cols)), n + 1)
        if image.ndim == 2:
            plt.gray()
        plt.hist(img.ravel(), 256, [0, 256])
        a.set_title(title)
    fig.set_size_inches(np.array(fig.get_size_inches()) * n_images)
    plt.show()


def show_images(images, cols=1, titles=None):
    """Display a list of images in a single figure with matplotlib.

    https://gist.github.com/soply/f3eec2e79c165e39c9d540e916142ae1

    Parameters
    ---------
    images: List of np.arrays compatible with plt.imshow.

    cols (Default = 1): Number of columns in figure (number of rows is
                        set to np.ceil(n_images/float(cols))).

    titles: List of titles corresponding to each image. Must have
            the same length as titles.
    """
    # assert ((titles is None) or (len(images) == len(titles)))
    n_images = len(images)
    if titles is None: titles = ['Image (%d)' % i for i in range(1, n_images + 1)]
    fig = plt.figure()
    for n, (image, title) in enumerate(zip(images, titles)):
        a = fig.add_subplot(cols, np.ceil(n_images / float(cols)), n + 1)
        if image.ndim == 2:
            plt.gray()
        plt.imshow(image)
        a.set_title(title)
    fig.set_size_inches(np.array(fig.get_size_inches()) * n_images)
    plt.show()


if __name__=='__main__':
    img = cv.imread('../../Datasets/Bitewing/2.jpg')
    # Denoising
    img = cv.fastNlMeansDenoisingColored(img, None, 10, 10, 7, 21)
    # Convert to Grayscale
    img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    # Resizing image
    img = cv.resize(img, (0,0), fx=0.4, fy=0.4)
    # Equalizing Hist
    equ = cv.equalizeHist(img)
    # CLAHE
    clahe = cv.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    cl1 = clahe.apply(equ)

    # Binarizing image using Otsu's Tresholding
    ret2, otsu = cv.threshold(cl1, 0, 255, cv.THRESH_BINARY + cv.THRESH_OTSU)

    # plot_hist([equ, cl1, otsu, d1, d2], cols=3, titles=[
    #     'Equalized', 'CLAHE', 'Otsu'
    # ])

    show_images([equ, cl1, otsu], cols=3, titles=[
        'Equalized', 'CLAHE', 'Otsu'
    ])

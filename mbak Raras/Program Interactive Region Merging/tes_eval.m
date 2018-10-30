path = 'E:\Raras\Kuliah\Semester 3\Program\Data ROI\';

% iminput = imread([path 'Input\IMG-13-2.bmp']);
% % iminput = rgb2gray(iminput);
% level = graythresh(iminput);
% imglobal = im2bw(iminput, level);
% figure, imshow(imglobal);
% imwrite(imglobal, [path 'Result_16082016\IMG-13-2_global.png'], 'WriteMode', 'overwrite'); 

im_output = imread([path 'Result_16082016\IMG-4-1_segmentationResult_3.bmp']);
% imwrite(imglobal, [path 'Result_16082016\IMG-13-2.png'], 'WriteMode', 'overwrite');
im_gt = imread([path 'GT\IMG-4-1-gt.bmp']);
im_gt = rgb2gray(im_gt);
me_eval = misclas_error(im_gt,im_output)
rae_eval = rae(im_gt,im_output)
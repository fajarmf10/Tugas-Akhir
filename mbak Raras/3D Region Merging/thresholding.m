function [ t ] = thresholding( img )

k = 4;
num_bins = 256;
hist = imhist(img,num_bins)';

[borders,mu,v,p] = EMThresh(img,k);

% figure, imhist(img);
% hold on
% for i=1:size(borders)
%     plot(borders(i), 0:max(hist(:)), 'r-');
% end
% hold off

t = borders(3)/255;
% imbw = im2bw(img,t);
% figure,imshow(imbw);

end


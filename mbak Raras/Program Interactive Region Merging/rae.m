function [ eval ] = rae( im_gt, im_out )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% im_gt = rgb2gray(im_gt);
im_gt = im2double(im_gt);
im_out = im2double(im_out);

gt_label = bwlabel(im_gt);
gt = regionprops(gt_label,'Area');
gtArea = sum([gt.Area]);

% im_out = im2bw(im_out);
out_label = bwlabel(im_out);
out = regionprops(out_label,'Area');
outArea = sum([out.Area]);


if (outArea < gtArea)
    eval = (gtArea-outArea)/gtArea;
else
    eval = (outArea-gtArea)/outArea;
end;

end


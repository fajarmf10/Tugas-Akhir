clear all
close all

datadir = '..\Data\';
name = '1_Bpk_Setyo';
inpdir = [datadir name '\axial\'];
gtdir = [datadir name '\axial_gt\'];

start = 1;
num = 200;
% levels = [128, 64, 32, 16, 8, 4, 2];
levels = [256];

%% 2D Region Merging

tic
for i=1:numel(levels)
    Q = levels(i);
    t2d = [];
    for j=start:num
        img = imread([inpdir num2str(j) '.bmp']);
%         se = strel('disk',20);
%         img = imtophat(img,se);
%         img = imadjust(img);
        t2d(j-start+1) = thresholding(img);
        imreg2d = srm3d(double(img), Q, 2);
        regfolder = [name '\2D Region - ' num2str(Q)];

        if ~exist(regfolder, 'dir')
            mkdir(regfolder);
        end
        
        imwrite(imreg2d, [regfolder '\' num2str(j) '.bmp']);
    end
    
    thresh2d = mean(t2d(:));
    for j=start:num
        imreg2d = imread([name '\' '2D Region - ' num2str(Q) '\' num2str(j) '.bmp']);
        imbw = im2bw(imreg2d, thresh2d);
        imbw = imfill(imbw, 'holes');
        bwfolder = [name '\2D Teeth - ' num2str(Q)];
        
        if ~exist(bwfolder, 'dir')
            mkdir(bwfolder);
        end
        
        imwrite(imbw, [bwfolder '\' num2str(j) '.bmp']);
    end
end
toc

%% 3D Region Merging

tic
axial = [];
t3d = [];
for i=start:num
    img = imread([inpdir num2str(i) '.bmp']);
%     se = strel('disk',20);
%     img = imtophat(img,se);
%     img = imadjust(img);
    axial(:,:,i-start+1) = double(img);
    t3d(i-start+1) = thresholding(img);
end

thresh3d = mean(t3d(:));
for i=1:numel(levels)
    Q = levels(i);
    imreg3d = srm3d(axial, Q, 3);
    
    regfolder = [name '\3D Region - ' num2str(Q)];
    bwfolder = [name '\3D Teeth - ' num2str(Q)];
    
    if ~exist(regfolder, 'dir')
        mkdir(regfolder);
    end
    if ~exist(bwfolder, 'dir')
        mkdir(bwfolder);
    end
    
    for j=start:num
        im = imreg3d(:,:,j-start+1);
        imbw = im2bw(im, thresh3d);
        imbw = imfill(imbw, 'holes');
        imwrite(im, [regfolder '\' num2str(j) '.bmp']);
        imwrite(imbw, [bwfolder '\' num2str(j) '.bmp']);
    end
end
toc

%% Evaluation

numdata = num-start+1;

for i=1:numel(levels)
    Q = levels(i);
    eval2d = [];
    eval3d = [];
    evalth = [];
    th = [];
    no = [];
    thresh = [];
    
    for j=start:num
        imin = imread([inpdir num2str(j) '.bmp']);
        th(j-start+1) = thresholding(imin);
    end
    
    thm = mean(th(:));
    for j=start:num
        im2d = imread([name '\' '2D Teeth - ' num2str(Q) '\' num2str(j) '.bmp']);
        im3d = imread([name '\' '3D Teeth - ' num2str(Q) '\' num2str(j) '.bmp']);
        
        imgt = imread([gtdir num2str(j) '.bmp']);
        if (max(imgt(:)) > 1)
            imgt = im2bw(imgt);
        end
        
        [acc_2d, sen_2d, spe_2d] = segmen_eval(imgt, im2d);
        [acc_3d, sen_3d, spe_3d] = segmen_eval(imgt, im3d);
        
        no(j-start+1) = j;
        thresh(j-start+1) = th(j-start+1);
        eval2d(j-start+1,:) = [acc_2d, sen_2d, spe_2d];
        eval3d(j-start+1,:) = [acc_3d, sen_3d, spe_3d];
    end

    mean2d = sum(eval2d,1)/numdata;
    mean3d = sum(eval3d,1)/numdata;
    
    xlswrite([name '\' 'evaluasi - teeth - ' num2str(Q) '.xlsx'], [no'], 1, ['A1']);
    xlswrite([name '\' 'evaluasi - teeth - ' num2str(Q) '.xlsx'], [thresh'; thm], 1, ['B1']);
    xlswrite([name '\' 'evaluasi - teeth - ' num2str(Q) '.xlsx'], [eval2d; mean2d], 1, ['D1']);
    xlswrite([name '\' 'evaluasi - teeth - ' num2str(Q) '.xlsx'], [eval3d; mean3d], 1, ['H1']);
end
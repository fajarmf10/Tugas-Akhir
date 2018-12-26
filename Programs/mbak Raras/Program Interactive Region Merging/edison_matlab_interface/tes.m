clear all
close all

I = imread('E:\Raras\Kuliah\Semester 3\Program\Data ROI\Input\IMG-1-1.bmp');
% I = imread('cameraman.tif');
figure, imshow(I);

hs = 3;
hr = 2;
M = 50;
[S L] = msseg(I,hs,hr,M);
figure, imshow(S);

Lbaru = padarray(L, [1 1], 'replicate', 'both');
A = ones(size(Lbaru));

for (i=2:(size(Lbaru,1)-1))
    for (j=2:(size(Lbaru,2)-1))
%             % kiri atas
%             if (Lbaru(i,j) ~= Lbaru(i-1,j-1))
%                 A(i,j) = 0;
%             end
%             % tengah atas
%             if (Lbaru(i,j) ~= Lbaru(i-1,j))
%                 A(i,j) = 0;
%             end
%             % kanan atas
%             if (Lbaru(i,j) ~= Lbaru(i-1,j+1))
%                 A(i,j) = 0;
%             end
%             % kiri
%             if (Lbaru(i,j) ~= Lbaru(i,j-1))
%                 A(i,j) = 0;
%             end
            % kanan
            if (Lbaru(i,j) ~= Lbaru(i,j+1))
                A(i,j) = 0;
            end
%             % kiri bawah
%             if (Lbaru(i,j) ~= Lbaru(i+1,j-1))
%                 A(i,j) = 0;
%             end
            % tengah bawah
            if (Lbaru(i,j) ~= Lbaru(i+1,j))
                A(i,j) = 0;
            end
            % kanan bawah
            if (Lbaru(i,j) ~= Lbaru(i+1,j+1))
                A(i,j) = 0;
            end
    end
end

A = A(((2:(size(Lbaru,1)-1))), ((2:(size(Lbaru,2)-1))));
% Abaru = 1-(bwmorph(1-A, 'skel', Inf));
figure, imshow(A);
% figure, imshow(Abaru);

I = im2single(I);
imreg = ones(size(I));
for (i=1:(size(A,1)))
    for (j=1:(size(A,2)))
        if (A(i,j) == 0)
            imreg(i,j,:) = 1;
        else imreg(i,j,:) = I(i,j,:);
        end
    end
end
        
figure, imshow(imreg);



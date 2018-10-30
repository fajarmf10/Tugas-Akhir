function me = misclas_error( img_gt, img_out)
% Menghitung persentase piksel yang salah diklasifikasi.
% Semakin rendah nilai ME maka semakin bagus segmentasenya.
% Output : me = persentase piksel yg salah diklasifikasi
% Input :
%   - img_gt = citra ground truth
%   - img_out = citra yang telah disegmentasi
%   - length, width = ukuran citra

count = 0;
total = 0;
img_gt = im2double(img_gt);
img_out = im2double(img_out);
[length, width] = size(img_gt);

for i=1:length
    for j=1:width
%         if(img_out(i,j) >= 200)
%             img_out(i,j) = 255;
%         end;
        if(img_gt(i,j) == img_out(i,j))
            count = count + 1;
        end;
        total = total + 1;
    end;
end;

% fprintf('FN + TP = %d\nTotal = %d\n', count, total);
me = 1 - (count/total);
        
end


function [ im_output ] = merge_ori( obj, bg, im_input_lama, L_lama, ck )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

status = 1;
obj = obj';
bg = bg';

if size(im_input_lama,3) ~= 3
    I = zeros(size(im_input_lama,1), size(im_input_lama,2), 3);
    I(:,:,1) = im_input_lama;
    I(:,:,2) = im_input_lama;
    I(:,:,3) = im_input_lama;
else
    I = im_input_lama;
end
I = rgb2hsv(I);

while (status == 1)
	status = 0;
	distance = [];
	for i=1:size(ck,1)
%		 mengecek apakah ck sudah habis atau belum
		if (ck(i,2) == 1)
			status = 1;
			[dist_obj, dist_bg] = multi_otsu_rgb(I, L_lama, ck(i,1), obj, bg);
			distance = [distance; i dist_obj dist_bg];
        end
    end
	
	if (status == 1)
		[min_obj, i_obj] = min(distance(:,2));
		[min_bg, i_bg] = min(distance(:,3));
	
		if (min_obj < min_bg)
			obj = [obj; ck(distance(i_obj,1),1)];
            ck(distance(i_obj,1),2) = 0;
		else
			bg = [bg; ck(distance(i_bg,1),1)];
            ck(distance(i_bg,1),2) = 0;
        end
	end
end

assignin('base', 'obj_ori', obj);
assignin('base', 'bg_ori', bg);

im_output_r = I(:,:,1);
im_output_g = I(:,:,2);
im_output_b = I(:,:,3);
for i=1:size(obj,1)
    im_output_r(L_lama==obj(i)) = 1;
    im_output_g(L_lama==obj(i)) = 1;
    im_output_b(L_lama==obj(i)) = 1;
end

for i=1:size(bg,1)
    im_output_r(L_lama==bg(i)) = 0;
    im_output_g(L_lama==bg(i)) = 0;
    im_output_b(L_lama==bg(i)) = 0;
end

im_output = im_output_r .* im_output_g .* im_output_b;

% im_output = zeros(size(im_input_lama));
% for i=1:size(ck,1)
%     im_output(L_lama==ck(i,1)) = 1;
% end

assignin('base', 'imoutput_ori', im_output);
% imwrite(im_output*255, 'E:\Raras\Kuliah\Semester 3\Program\Result\merge.png', 'WriteMode', 'overwrite'); 


end


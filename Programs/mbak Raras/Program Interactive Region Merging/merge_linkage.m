function [ im_output, h ] = merge_linkage( obj, bg, im_input_lama, L_lama, ck, h )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

status = 1;
obj = obj';
bg = bg';

waitbar(10/100, h, sprintf('List the unmarked regions..'));

if size(im_input_lama,3) ~= 3
    I = zeros(size(im_input_lama,1), size(im_input_lama,2), 3);
    I(:,:,1) = im_input_lama;
    I(:,:,2) = im_input_lama;
    I(:,:,3) = im_input_lama;
else
    I = im_input_lama;
end
I = rgb2hsv(I);
arrhasil = [];
indx = 1;
% while (status == 1)
	status = 0;
	distance = [];
    step = size(ck,1);
	for i=1:size(ck,1)
        progress = (((i - 0) / step) * 80) + 10;
        waitbar(progress/100, h, sprintf('Calculating the distance..'));
%		 mengecek apakah ck sudah habis atau belum
		if (ck(i,2) == 1)
			status = 1;
			[dist_obj, dist_bg] = multi_otsu_rgb_edit(I, L_lama, ck(i,1), obj, bg);
			distance = [distance; i dist_obj dist_bg];   
%           region
            arrhasil(i, 1) = ck(i,1);
%           object
            arrhasil(i, 2) = dist_obj;
%           background
            arrhasil(i, 3) = dist_bg;   
        end      
%         fprintf('%d - %d - %d\n', arrhasil(ck(1,1), 1), arrhasil(i, 2), arrhasil(i, 3));
        save arrhasil.mat arrhasil;

%   save arrhasil.mat arrhasil -double;
    end
Z=linkage(arrhasil,'single');
figure();
dendrogram(Z);
save Z.mat Z;

%add pada array objek
sizeobj = size(obj);
% disp(sizeobj(1));
sizebg = size(bg);
% disp(sizebg(1));
sizearrhasil = size(arrhasil);
for i=1:size(Z)
    if(Z(i,3)==2 )
%       kolom 2        
        if(Z(i,2)<=sizearrhasil(1))
%             disp(arrhasil(Z(i,2)));
            sizeobj(1) = sizeobj(1) +1;
%             disp(sizeobj(1));
            obj(sizeobj(1)) = arrhasil(Z(i,2),1);
        end
%       kolom 1
        if(Z(i,1)<=sizearrhasil(1))
%             disp(arrhasil(Z(i,1)));
            sizeobj(1) = sizeobj(1) +1;
%             disp(sizeobj(1));
            obj(sizeobj(1)) = arrhasil(Z(i,1),1);
        end
    elseif ( Z(i,3)==3|| Z(i,3)==4|| Z(i,3)==5|| Z(i,3)==1)
%       kolom 2
        if(Z(i,2)<=sizearrhasil(1))
%             disp(arrhasil(Z(i,2)));
            sizebg(1) = sizebg(1) +1;
%             disp(sizebg(1));
            bg(sizebg(1)) = arrhasil(Z(i,2),1);
        end
%         kolom 1
        if(Z(i,1)<=sizearrhasil(1))
%             disp(arrhasil(Z(i,1)));
            sizebg(1) = sizebg(1) +1;
%             disp(sizebg(1));
            bg(sizebg(1)) = arrhasil(Z(i,1),1);
        end
    else
%         kolom 2
        if(Z(i,2)<=sizearrhasil(1))
%             disp(arrhasil(Z(i,2)));
            sizebg(1) = sizebg(1) +1;
%             disp(sizebg(1));
            bg(sizebg(1)) = arrhasil(Z(i,1),1);
        end
%         kolom 1
        if(Z(i,1)<=sizearrhasil(1))
%             disp(arrhasil(Z(i,1)));
            sizebg(1) = sizebg(1) +1;
%             disp(sizebg(1));
            bg(sizebg(1)) = arrhasil(Z(i,1),1);
        end
    end
end
% 	if (status == 1)
% 		[min_obj, i_obj] = min(distance(:,2));
% 		[min_bg, i_bg] = min(distance(:,3));
% 	
% 		if (min_obj < min_bg)
% 			obj = [obj; ck(distance(i_obj,1),1)];
%             ck(distance(i_obj,1),2) = 0;
% 		else
% 			bg = [bg; ck(distance(i_bg,1),1)];
%             ck(distance(i_bg,1),2) = 0;
%         end
%     end
% end

assignin('base', 'obj_link', obj);
assignin('base', 'bg_link', bg);

waitbar(95/100, h, sprintf('Processing the output image..'));

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

assignin('base', 'imoutput_link', im_output);
% imwrite(im_output*255, 'E:\Raras\Kuliah\Semester 3\Program\Result\merge.png', 'WriteMode', 'overwrite'); 


end


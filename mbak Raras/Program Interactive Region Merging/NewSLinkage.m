I=imread('20_P_08_Ki_M2.png');
subplot(2,2,1);
imshow(I);
load('L_lama.mat','L_lama');
load('im_input_lama.mat', 'im_input_lama');
size('im_input_lama.mat');
load('obj.mat','obj');
load('bg.mat','bg');

neighbor = double.empty;
neighbor = adjacency_matrix(L_lama);
inputNew = im_input_lama;
for i=1:size(obj_x,1)
    inputNew(obj_x(i),obj_y(i))=1.0;
end
for i=1:size(bg_x,1)
    inputNew(bg_x(i), bg_y(i))=0.0;
end
z=0;
for k=1:size(neighbor,1)
    sum=0;
    for i=1:size(L_lama,1)
        for j=1:size(L_lama,2)
            if(L_lama(i,j)==neighbor(k))
               sum=sum+inputNew(i,j);
               z=z+1;
            end
        end
    end
    neighbor(k,3)=sum / z;
end;
obj=obj;
bg=bg';
for k=1:1:size(neighbor,1)
    for i=1:size(obj)
        if(neighbor(k)==obj(i))
            neighbor(k,4)=1;
        else
            neighbor(k,4)=3;
        end
    end
end
for k=1:1:size(neighbor,1)
    for i=1:size(bg)
        if(neighbor(k)==bg(i))
            neighbor(k,4)=2;
        end
    end
end


% 
% [adj_matrix] = adjacency_matrix(matrixF);

%linkad baru

% Z=linkageold(matrixF, 'single');
% subplot(2,2,2);
% dendrogram(Z);
% [row,col]=ind2sub(L,I);
% matI=I(:);
% %Y=double(matI);
% Z = linkage(matI, 'single');
% subplot(2,2,2);
% dendogram(Z);
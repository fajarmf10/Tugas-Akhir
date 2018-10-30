X=arrhasil;
% disp(X);
Z=linkage(arrhasil,'single');
c = cluster(Z,'maxclust',2);
cutoff = median(Z(end-1,2));
dendrogram(Z);
save Z.mat Z;

%add pada array objek
sizeobj = size(obj);
% disp(sizeobj(1));
sizebg = size(bg);
% disp(sizebg(1));
sizearrhasil = size(arrhasil);
for i=1:size(Z)
    if(Z(i,3)==1)
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
    elseif(Z(i,3)==2 || Z(i,3)==3)
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
            sizeobj(1) = sizeobj(1) +1;
%             disp(sizeobj(1));
            obj(sizeobj(1)) = arrhasil(Z(i,2),1);
        end
%         kolom 1
        if(Z(i,1)<=sizearrhasil(1))
%             disp(arrhasil(Z(i,1)));
            sizeobj(1) = sizeobj(1) +1;
%             disp(sizeobj(1));
            obj(sizeobj(1)) = arrhasil(Z(i,1),1);
        end
    end
end
% disp(obj);
% disp(bg);

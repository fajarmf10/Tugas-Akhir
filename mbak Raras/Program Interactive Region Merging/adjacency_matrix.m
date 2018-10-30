function [neighbor] = adjacency_matrix(L_lama)
a = size(L_lama);
k = L_lama;
l = 1;
neighbor = double.empty;
for i = 1:a(1)
    for j = 1:a(2)
        %disimpan nilai dari posisi tersebut
        vnow = k(i,j);        
        %dicek apakah bagian kanan, kiri, atas, bawah, diagonal2ny nilainya
        %memiliki nilai yang berbeda dari vnow
        %kanan
        if(j ~= a(2))
            if(vnow ~= k(i, j+1)) 
%                 disp(vnow);
                checkemptyarr = isempty(neighbor);
%                 disp(checkemptyarr);
                if(checkemptyarr==0)
                    checkmember = ismember([vnow k(i, j+1)], neighbor);
%                     disp(checkmember);
                    if(checkmember(1)~=1 && checkmember(2)~=1)
%                         disp('tidak sama');
                        neighbor(l, 1) = vnow;      
                        neighbor(l, 2) = k(i, j+1);

                        l = l+1;
                    elseif(checkmember(1)==1 && checkmember(2)~=1)
                        neighbor(l, 1) = vnow;      
                        neighbor(l, 2) = k(i, j+1);

                        l = l+1;
                    end
                else
%                     disp('pertama');
                    neighbor(l, 1) = vnow;                
                    neighbor(l, 2) = k(i, j+1);

                    l = l+1;
                end
            end
        end

    end
end
end
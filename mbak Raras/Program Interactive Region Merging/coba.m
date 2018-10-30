
function coba

disp('....Single Linkage Agglomarative Algorithm....');
I=imread('20_P_08_Ki_M2.png');
imshow(I);
doubleI=double(I);
N=doubleI
 %N=[0 0; .5 0;0 2; 2 2;2.5 8; 6 3; 7 3]
% N=[ 1 1; 1.5 1.5;5 5; 3 4;4 4 ; 3 3.5]
    [m,n]= size(N);
  for i=1:m 
           for j=1:m
                mini_dist =(N(i,1)-N(j,1))^2 +(N(i,2)-N(j,2))^2; % finding minimum distant each point
                 mini_dist = sqrt(mini_dist);
                    ty(i,j)=mini_dist;
           end
    end
    disp(' Euclidean Distance');
    disp(ty);
        
   while 1

        [l,z]=min_dist(ty);
        [ty,z] = im2uint8(mini_swap(ty,l,z));

          if(l>z) te=l;
                l=z;
                z=te;
          end
        [d,e]=size(ty);  
        for b=2:d
            for f=1:b
              ty(b,f) = ty(f,b);
            end
        end
        disp('After Reducing Dimension:');
        [ty]= delete(ty,z);
        disp(ty);
        [d,e]=size(ty);
        disp(' Dsl = ');
        disp(ty);
        if d==2 && e==2
          break;
        end
   end
 
end

function [my]= delete(my,z)
      my([z],:) = [];
      my(:,[z])=[];
end



function [ty,z] = mini_swap(ty,l,z)
 [o,p] = size(ty);
    for j=1:o
      if(double(ty(l,j)> ty(z,j)))  
          ty(l,j)=ty(z,j);
      end
    end
 end

function [l,z] = min_dist(ty)
[m,n]=size(ty);
l=0;
z=0;
mino=999999999999999;
     for i=1:m
        for j=1:m
          if  ty(i,j)<mino && ty(i,j)>0
                        mino=ty(i,j);
                        l=i;
                        z=j;
              
           end
        end
    end
disp('Minimum value between cluster: ');
  disp(l);
  disp(z);
end

function [ imfinal ] = srm3d( I, Q, dim )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin<=2
    dim = 2;
end

if nargin==1
    Q = 256;
end

smallest_region_allowed=1;
size_image=size(I);

if dim==2
    [Ix,Iy] = imgradientxy(I);
    normgradient=sqrt(Ix.^2 + Iy.^2);

    % Menukar Ix dan Iy karena di matlab koordinat xy citra tertukar
    Ix(:,end)=[];
    Iy(end,:)=[];

    [~,index]=sort(abs([Iy(:);Ix(:)]));
    n_pixels=size_image(1)*size_image(2);
    
    % create matrix sequence of [1 ... numb.pixels]
    maps=reshape(1:n_pixels,size_image(1:2));
    treerank=zeros(size_image(1:2));
    size_segments=ones(size_image(1:2));            
    image_seg=I;
    
    %Building pairs
    n_pairs=numel(index);
    idx1=reshape(maps(1:end-1,:),[],1);
    idx2=reshape(maps(:,1:end-1),[],1);

    pairs1=[ idx1;idx2 ];
    pairs2=[ idx1+1;idx2+size_image(1) ];
    
elseif dim==3
    [Ix,Iy,Iz] = imgradientxyz(I);
    normgradient=sqrt(Ix.^2 + Iy.^2 + Iz.^2);

    % Menukar Ix dan Iy karena di matlab koordinat xy citra tertukar
    Ix(:,end,:)=[];
    Iy(end,:,:)=[];
    Iz(:,:,end)=[];

    [~,index]=sort(abs([Iy(:);Ix(:);Iz(:)]));
    n_pixels=size_image(1)*size_image(2)*size_image(3);
    
    % create matrix sequence of [1 ... numb.pixels]
    maps=reshape(1:n_pixels,size_image(1:3));

    treerank=zeros(size_image(1:3));
    size_segments=ones(size_image(1:3));            % berapa banyak region yang bergabung ke dia
    image_seg=I;
    
    %Building pairs
    n_pairs=numel(index);
    idx1=reshape(maps(1:end-1,:,:),[],1);
    idx2=reshape(maps(:,1:end-1,:),[],1);
    idx3=reshape(maps(:,:,1:end-1),[],1);

    pairs1=[ idx1;idx2;idx3 ];
    pairs2=[ idx1+1;idx2+size_image(1);idx3+(size_image(1)*size_image(2)) ];
end
        
for i=1:n_pairs
	C1=pairs1(index(i));
	C2=pairs2(index(i));
        
	%Union-Find structure, here are the finds, average complexity O(1)
	while (maps(C1)~=C1 ); C1=maps(C1); end
	while (maps(C2)~=C2 ); C2=maps(C2); end
        
	% Compute the predicate, region merging test
	g=256;
	logdelta=2*log(6*n_pixels);          
        
	d=(image_seg(C1)-image_seg(C2))^2;
        
	logreg1 = min(g,size_segments(C1))*log(1.0+size_segments(C1));
	logreg2 = min(g,size_segments(C2))*log(1.0+size_segments(C2));
        
	dev1=((g*g)/(2.0*Q*size_segments(C1)))*(logreg1 + logdelta);
	dev2=((g*g)/(2.0*Q*size_segments(C2)))*(logreg2 + logdelta);
        
	dev=dev1+dev2;
            
	predicat=( (d<dev) );
        
	if (((C1~=C2)&&predicat) ||  xor(size_segments(C1)<=smallest_region_allowed, size_segments(C2)<=smallest_region_allowed))
        % Find the new root for both regions
        if treerank(C1) > treerank(C2)
            maps(C2) = C1; reg=C1;
        elseif treerank(C1) < treerank(C2)
            maps(C1) = C2; reg=C2;
        elseif C1 ~= C2
            maps(C2) = C1; reg=C1;
            treerank(C1) = treerank(C1) + 1;
        end
            
        if C1~=C2
            % Merge regions
            nreg=size_segments(C1)+size_segments(C2);
            image_seg(reg)=(size_segments(C1)*image_seg(C1)+size_segments(C2)*image_seg(C2))/nreg;
            size_segments(reg)=nreg;
        end
    end
end

while 1
	map_ = maps(maps) ;
	if isequal(map_,maps) ; break ; end
    maps = map_ ;
end
    
images = image_seg(maps);
imfinal = uint8(images);

end


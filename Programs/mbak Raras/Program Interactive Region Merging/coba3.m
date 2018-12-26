rng('default') % For reproducibility
X = rand(3,2);
% X(1,1) = NaN;
D1 = pdist(X);
D2 = pdist(X,@naneucdist);
dist_obj=pdist(X,@multi_otsu_rgb_obj);
Z = linkage(dist_obj,'single');
dendrogram(Z);

function [dist_obj] = multi_otsu_rgb_obj(I, L, ck, obj)

I_r = I(:,:,1);
I_g = I(:,:,2);
I_b = I(:,:,3);

% Cluster k
omega_k = sum(L(:)==ck) / ((size(L,1))*(size(L,2)));
mu_k_r = sum(I_r(L==ck)) / sum(L(:)==ck);
mu_k_g = sum(I_g(L==ck)) / sum(L(:)==ck);
mu_k_b = sum(I_b(L==ck)) / sum(L(:)==ck);


assignin('base', 'omega_k', omega_k);
% assignin('base', 'mu_k', mu_k);

% Cluster objek
dist_obj = 0;
for i=1:size(obj,1)
    omega_o = sum(L(:)==obj(i)) / ((size(L,1))*(size(L,2)));
    mu_o_r = sum(I_r(L==obj(i))) / sum(L(:)==obj(i));
    mu_o_g = sum(I_g(L==obj(i))) / sum(L(:)==obj(i));
    mu_o_b = sum(I_b(L==obj(i))) / sum(L(:)==obj(i));
    sigma_b = omega_k * omega_o * (sqrt((mu_o_r - mu_k_r)^2 + (mu_o_g - mu_k_g)^2 + (mu_o_b - mu_k_b)^2));
    sigma_w=((obj(i)-(sqrt((mu_o_r - mu_k_r)^2 + (mu_o_g - mu_k_g)^2 + (mu_o_b - mu_k_b)^2))^2)*omega_o)/omega_o;
    dist_obj = sigma_b*sigma_w;
    
end


end 
function D2 = naneucdist(XI,XJ)  
%NANEUCDIST Euclidean distance ignoring coordinates with NaNs
n = size(XI,2);
sqdx = (XI-XJ).^2;
nstar = sum(~isnan(sqdx),2); % Number of pairs that do not contain NaNs
nstar(nstar == 0) = NaN; % To return NaN if all pairs include NaNs
D2squared = nansum(sqdx,2).*n./nstar; % Correction for missing coordinates
D2 = sqrt(D2squared);
end

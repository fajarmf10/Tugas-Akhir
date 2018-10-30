function [ dist_bg] = multi_otsu_rgb_bg(I, L, ck, bg)

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
% Cluster background
dist_bg = 0;
for i=1:size(bg,1)
    omega_g = sum(L(:)==bg(i)) / ((size(L,1))*(size(L,2)));
    mu_g_r = sum(I_r(L==bg(i))) / sum(L(:)==bg(i));
    mu_g_g = sum(I_g(L==bg(i))) / sum(L(:)==bg(i));
    mu_g_b = sum(I_b(L==bg(i))) / sum(L(:)==bg(i));
    sigma_b = omega_k * omega_g * (sqrt((mu_g_r - mu_k_r)^2 + (mu_g_g - mu_k_g)^2 + (mu_g_b - mu_k_b)^2));
    sigma_w=((bg(i)-(sqrt((mu_g_r - mu_k_r)^2 + (mu_g_g - mu_k_g)^2 + (mu_g_b - mu_k_b)^2))^2)*omega_g)/(1-omega_g);
    dist_bg = sigma_b*sigma_w;
end


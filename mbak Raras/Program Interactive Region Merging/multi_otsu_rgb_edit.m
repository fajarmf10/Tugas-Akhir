function [dist_obj, dist_bg] = multi_otsu_rgb_edit(I, L, ck, obj, bg)


%% RGB

% I_r = I(:,:,1);
% I_g = I(:,:,2);
% I_b = I(:,:,3);
% 
% % Cluster k
% omega_k = sum(L(:)==ck) / ((size(L,1))*(size(L,2)));
% mu_k_r = sum(I_r(L==ck)) / sum(L(:)==ck);
% mu_k_g = sum(I_g(L==ck)) / sum(L(:)==ck);
% mu_k_b = sum(I_b(L==ck)) / sum(L(:)==ck);
% teta_k_r = (sum(I_r(L==ck))-mu_k_r)^2 / sum(L(:)==ck);
% teta_k_g = (sum(I_r(L==ck))-mu_k_g)^2 / sum(L(:)==ck);
% teta_k_b = (sum(I_r(L==ck))-mu_k_b)^2 / sum(L(:)==ck);
% 
% assignin('base', 'omega_k', omega_k);
% % assignin('base', 'mu_k', mu_k);
% 
% % Cluster objek
% dist_obj = 0;
% for i=1:size(obj,1)
%     omega_o = sum(L(:)==obj(i)) / ((size(L,1))*(size(L,2)));
%     mu_o_r = sum(I_r(L==obj(i))) / sum(L(:)==obj(i));
%     mu_o_g = sum(I_g(L==obj(i))) / sum(L(:)==obj(i));
%     mu_o_b = sum(I_b(L==obj(i))) / sum(L(:)==obj(i));
%     teta_o_r = (sum(I_r(L==obj(i)))-mu_o_r)^2 / sum(L(:)==obj(i));
%     teta_o_g = (sum(I_r(L==obj(i)))-mu_o_g)^2  / sum(L(:)==obj(i));
%     teta_o_b = (sum(I_r(L==obj(i)))-mu_o_b)^2  / sum(L(:)==obj(i));
%     sigma_b = omega_k * omega_o * (sqrt((mu_o_r - mu_k_r)^2 + (mu_o_g - mu_k_g)^2 + (mu_o_b - mu_k_b)^2));
%     sigma_w= (omega_o * (sqrt((teta_o_r)^2 + (teta_o_g)^2 + (teta_o_b)^2)))+(omega_k * (sqrt(( teta_k_r)^2 + (teta_k_g)^2 + (teta_k_b)^2)));
%     dist_obj = dist_obj+(sigma_b*sigma_w);
% %     dist_obj_new = apa(dist_obj,sigma_b,sigma_w);
%     
% end
% 
% % Cluster background
% dist_bg = 0;
% for i=1:size(bg,1)
%     omega_g = sum(L(:)==bg(i)) / ((size(L,1))*(size(L,2)));
%     mu_g_r = sum(I_r(L==bg(i))) / sum(L(:)==bg(i));
%     mu_g_g = sum(I_g(L==bg(i))) / sum(L(:)==bg(i));
%     mu_g_b = sum(I_b(L==bg(i))) / sum(L(:)==bg(i));
%     teta_g_r = (sum(I_r(L==bg(i)))-mu_g_r)^2 / sum(L(:)==bg(i));
%     teta_g_g = (sum(I_r(L==bg(i)))-mu_g_g)^2  / sum(L(:)==bg(i));
%     teta_g_b = (sum(I_r(L==bg(i)))-mu_g_b)^2  / sum(L(:)==bg(i));
%     sigma_b = omega_k * omega_g * (sqrt((mu_g_r - mu_k_r)^2 + (mu_g_g - mu_k_g)^2 + (mu_g_b - mu_k_b)^2));
%     sigma_w= (omega_g * (sqrt((teta_g_r)^2 + (teta_g_g)^2 + (teta_g_b)^2)))+(omega_k * (sqrt(( teta_k_r)^2 + (teta_k_g)^2 + (teta_k_b)^2)));
%     dist_bg =dist_bg+( sigma_b*sigma_w);
% end


%% Grayscale

% Cluster k
omega_k = sum(L(:)==ck) / ((size(L,1))*(size(L,2)));
mu_k = sum(I(L==ck)) / sum(L(:)==ck);
teta_k = (sum(I(L==ck))-mu_k)^2 / sum(L(:)==ck);

assignin('base', 'omega_k', omega_k);
% assignin('base', 'mu_k', mu_k);

% Cluster objek
dist_obj = 0;
for i=1:size(obj,1)
    omega_o = sum(L(:)==obj(i)) / ((size(L,1))*(size(L,2)));
    mu_o = sum(I(L==obj(i))) / sum(L(:)==obj(i));
    teta_o = (sum(I(L==obj(i)))-mu_o)^2 / sum(L(:)==obj(i));
    sigma_b = omega_k * omega_o * sqrt((mu_o - mu_k)^2);
    sigma_w= (omega_o * sqrt((teta_o)^2))+(omega_k * sqrt(( teta_k)^2));
    dist_obj = dist_obj+(sigma_b*sigma_w);
%     dist_obj_new = apa(dist_obj,sigma_b,sigma_w);
    
end

% Cluster background
dist_bg = 0;
for i=1:size(bg,1)
    omega_g = sum(L(:)==bg(i)) / ((size(L,1))*(size(L,2)));
    mu_g = sum(I(L==bg(i))) / sum(L(:)==bg(i));
    teta_g = (sum(I(L==bg(i)))-mu_g)^2 / sum(L(:)==bg(i));
    sigma_b = omega_k * omega_g * sqrt((mu_g - mu_k)^2);
    sigma_w= (omega_g * sqrt((teta_g)^2))+(omega_k * sqrt(( teta_k)^2));
    dist_bg =dist_bg+( sigma_b*sigma_w);
end

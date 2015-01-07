function cropped_image = crop_image(img)

[h w c] = size(img);
h_t = floor(h/4);
w_t = floor(w/4);

left = zeros(1, c);
right = zeros(1, c);
top = zeros(1, c);
bottom = zeros(1, c);

for i = 1:c
    tmp_e = edge(img(:,:,i), 'canny', 0.01);
    tmp_ver_ave = sum(tmp_e, 1)/h;
    tmp_hor_ave = sum(tmp_e, 2)/w;
    
    tmp_ver_mask = tmp_ver_ave > 1.5*mean(tmp_ver_ave);
    tmp_hor_mask = tmp_hor_ave > 1.5*mean(tmp_hor_ave);
    
    left(i) = find(tmp_ver_mask(1:h_t), 1, 'last');
    right(i) = find(tmp_ver_mask(3*h_t:end), 1, 'first');
    
    top(i) = find(tmp_hor_mask(1:w_t), 1, 'last');
    bottom(i) = find(tmp_hor_mask(3*w_t:end), 1, 'first');
end

left
right
top
bottom

c_l = max(left)
c_r = 3*w_t + min(right)
c_t = max(top)
c_b = 3*h_t + min(bottom)

cropped_image = imcrop(img, [c_l c_t (c_r-c_l) (c_b-c_t)]);

% 
% h_tenth = floor(h/10);
% w_tenth = floor(w/10);
% 
% img_e = edge(img_g, 'canny', 0.01);
% ver_ave = sum(img_e, 1)/h;
% hor_ave = sum(img_e, 2)/w;
% 
% subplot(1,3,1), imshow(img_e)
% subplot(1,3,2), plot(ver_ave)
% subplot(1,3,3), plot(hor_ave)
% 
% ver_mask = ver_ave > 1.5*mean(ver_ave);
% hor_mask = hor_ave > 1.5*mean(hor_ave);
% 
% left = find(ver_mask(1:h_tenth), 1, 'last');
% right = find(ver_mask(9*h_tenth:end), 1, 'first');
% 
% top = find(hor_mask(1:w_tenth), 1, 'last');
% bottom = find(hor_mask(9*w_tenth:end), 1, 'first');
% 
% right = right+9*h_tenth;
% bottom = bottom+9*w_tenth;
% 
% cropped_image = imcrop(img, [left top (right-left) (bottom-top)]);
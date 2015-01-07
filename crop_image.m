function cropped_image = crop_image(img)
% Use Matlab's edge function with the canny method. This finds the local
% maxima of the gradient. In other words, where the difference between
% neighbouring values peak. 

[h w c] = size(img);

% Only use the top- and left-most tenth of the image, and assume that the
% corresponding borders on the other sides are roughly the same.
c_img = img(1:floor(h/10), 1:floor(w/10), :);

vert = zeros(1, c);
horz = zeros(1, c);

for i = 1:c
    % Find edges
    tmp_e = edge(c_img(:,:,i), 'canny', 0.1);
    
    % Find mean value and mask the values.
    tmp_ver_ave = mean(tmp_e, 1);
    tmp_hor_ave = mean(tmp_e, 2);
    tmp_ver_mask = tmp_ver_ave > 3*mean(tmp_ver_ave);
    tmp_hor_mask = tmp_hor_ave > 3*mean(tmp_hor_ave);
    
    % Find last values.
    vert(i) = find(tmp_ver_mask, 1, 'last');
    horz(i) = find(tmp_hor_mask, 1, 'last');
end

% Avoid ugly miscoloured borders.
vert_crop = max(vert);
horz_crop = max(horz);

cropped_image = imcrop(img, [horz_crop vert_crop (w-2*horz_crop) (h-2*vert_crop)]);

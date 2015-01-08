function cropped_image = crop_image(img, threshold)
% Use Matlab's edge function with the canny method. This finds the local
% maxima of the gradient. In other words, where the difference between
% neighbouring values peak. 

[h w c] = size(img);

% Only use the top- and left-most tenth of the image, and assume that the
% corresponding borders on the other sides are roughly the same. This is to
% increase performance. One could, of course, be very thorough and examine
% more of the corners.
c_img = img(1:floor(h/10), 1:floor(w/10), :);

vert = 0;
horz = 0;

for i = 1:c
    % Find edges
    tmp_e = edge(c_img(:,:,i), 'canny', 0.1);
    
    % Find mean value and mask the values.
    tmp_ver_ave = mean(tmp_e, 1);
    tmp_hor_ave = mean(tmp_e, 2);
    if nargin < 2
        threshold = 3*mean(tmp_hor_ave);
    end
    tmp_ver_mask = tmp_ver_ave > threshold;
    tmp_hor_mask = tmp_hor_ave > threshold;
    
    % Find last values. Semi-ugly.
    tmp_vert = find(tmp_ver_mask, 1, 'last');
    tmp_horz = find(tmp_hor_mask, 1, 'last');
    
    if tmp_vert > vert
        vert = tmp_vert;
    end
    if tmp_horz > horz
        horz = tmp_horz;
    end
end

% Avoid ugly miscoloured borders.
% vert_crop = max(vert);
% horz_crop = max(horz);

cropped_image = imcrop(img, [horz vert (w-2*horz) (h-2*vert)]);

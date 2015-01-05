clear all;
%% Load and prepare image

disp('Loading image...');
tic
im_load = imread('images/00172v.jpg');
% divide into three images
im_size = size(im_load);
im_height = floor(im_size(1)/3);

im_b = im_load(1:im_height,:);
im_g = im_load(im_height+1:im_height*2,:);
im_r = im_load(im_height*2+1:3*im_height,:);

% save in one rgb image
img = cat(3, im_r, im_g, im_b);

% cleanup workspace
clear im_*;
toc

%% Align images
% Use sum of squared differences to find the best match!
% Issue: no rotation!

% We want to work with 300 pixels wide images. It seems neat.

scale = 300/size(img, 2);
img_re = imresize(img, scale);


disp('Aligning images...');
tic
offset = 20;

diff_r = inf;
diff_b = inf;

loop = 1;

% find how we should move our images!
for x_s = -offset:offset
    for y_s = -offset:offset
        % move images around
        tmp_r = circshift(img_re(:,:,1), [x_s y_s]);
        tmp_b = circshift(img_re(:,:,3), [x_s y_s]);
        
        % Find sum of squared diff - in other words: compare our moved red
        % and blue images with our green image, and look for the best
        % match (= when the difference is the smallest found).
        ssd_r = sum(sum((img_re(:,:,2) - tmp_r).^2));
        ssd_b = sum(sum((img_re(:,:,2) - tmp_b).^2));
        
        if ssd_r < diff_r
            diff_r = ssd_r;
            offset_r = [x_s y_s];
        end
        if ssd_b < diff_b
            diff_b = ssd_b;
            offset_b = [x_s y_s];
        end
        
        ssd_r_stat(loop) = ssd_r;
        ssd_b_stat(loop) = ssd_b;
        
        loop = loop+1;
    end
end

% Actually align our images, and do so on the un-scaled ones.
offset_r = round(offset_r * scale);
offset_b = round(offset_b * scale);

img_res = img;
img_res(:,:,1) = circshift(img(:,:,1), offset_r);
img_res(:,:,3) = circshift(img(:,:,3), offset_b);

toc

imshow(img);

%% Detect borders
% Use matlab's edge function with the canny method. This finds the local
% maxima of the gradient. In other words, where the difference between
% neighbouring values peak. 

% edge_r = edge(img(:,:,1), 'canny', 0.1);
% ave_x_ = sum(edge_r,1)/img_size(1);














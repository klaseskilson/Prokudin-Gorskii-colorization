clear all;
%% Load and prepare image

disp('Loading image...');
tic
im_load = imread('images/00106v.jpg');
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
% Issue: no rotation
disp('Finding edges...');
tic
% We want to work with 200 pixels wide images. It seems neat.
padding = floor([.2*size(img, 2), .2*size(img, 1), .6*size(img, 2), .6*size(img, 1)]);
img_c = imcrop(img, padding);
scale = 200/size(img_c, 2);
% scale = 1;
img_re = imresize(img_c, scale);

img_e(:,:,1) = edge(img_re(:,:,1), 'canny', 0.1);
img_e(:,:,2) = edge(img_re(:,:,2), 'canny', 0.1);
img_e(:,:,3) = edge(img_re(:,:,3), 'canny', 0.1);
toc
disp('Aligning images...');
tic
offset = 10;

best_r = 0;
best_b = 0;

loop = 1;
step = 1;

% find how we should move our images!
for y_s = -offset:step:offset
    for x_s = -offset:step:offset
        % move images around
        tmp_r = circshift(img_e(:,:,1), [x_s y_s]);
        tmp_b = circshift(img_e(:,:,3), [x_s y_s]);
        
        % Find sum of squared diff - in other words: compare our moved red
        % and blue images with our green image, and look for the best
        % match (= when the difference is the smallest found).
        
        match_r = sum(sum(tmp_r.*img_e(:,:,2)));
        match_b = sum(sum(tmp_b.*img_e(:,:,2)));
        
        if match_r > best_r
            best_r = match_r;
            offset_r = [x_s y_s];
        end
        if match_b > best_b
            best_b = match_b;
            offset_b = [x_s y_s];
        end
        
        ssd_r_stat(loop) = match_r;
        ssd_b_stat(loop) = match_b;
        
        loop = loop+1;
    end
end

% Actually align our images, and do so on the un-scaled ones.
offset_r = round(offset_r / scale);
offset_b = round(offset_b / scale);

img_res = img;
img_res(:,:,1) = circshift(img(:,:,1), offset_r);
img_res(:,:,3) = circshift(img(:,:,3), offset_b);

toc

subplot(1,2,1), plot(ssd_r_stat)
subplot(1,2,2), plot(ssd_b_stat)

figure
imshow(img_res);

%% Detect borders
% Use matlab's edge function with the canny method. This finds the local
% maxima of the gradient. In other words, where the difference between
% neighbouring values peak. 

% edge_r = edge(img(:,:,1), 'canny', 0.1);
% ave_x_ = sum(edge_r,1)/img_size(1);














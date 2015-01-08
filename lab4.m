clear all;
%% Load and prepare image

disp('Loading and chopping image...');
tic
im_load = im2double(imread('images/01443a.tif'));
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

%% Finding edges

disp('Scaling images and finding edges...');
tic
padding = floor([.2*size(img, 2), .2*size(img, 1), .6*size(img, 2), .6*size(img, 1)]);
img_c = imcrop(img, padding);
img_re = reduce_image(img_c);
scale = size(img_re, 2) / size(img_c, 2);

img_r = edge(img_re(:,:,1), 'canny', 0.1); % red
img_g = edge(img_re(:,:,2), 'canny', 0.1); % green
img_b = edge(img_re(:,:,3), 'canny', 0.1); % blue
toc

%% Align images
% Issues: 
% - no rotation
% - loops for both red and blue channel. Idealy, this would be done in one
% loop only.

disp('Aligning images...');
tic

movement = 10;

% find how we should move our images!
offset_r = align_image(img_r, img_g, movement);
offset_b = align_image(img_b, img_g, movement);

% Actually align our images, and do so on the un-scaled ones.
offset_r = round(offset_r / scale);
offset_b = round(offset_b / scale);

aligned = img;
aligned(:,:,1) = circshift(img(:,:,1), offset_r);
aligned(:,:,3) = circshift(img(:,:,3), offset_b);

toc

% imshow(aligned);

%% Detect borders

disp('Detecting borders...');
tic
cropped = crop_image(aligned);
toc

% imshowpair(aligned, cropped, 'montage');

%% Color correction!

disp('Correcting colors...');
tic
corrected = color_correct(cropped);
toc

imshowpair(cropped, corrected, 'montage');
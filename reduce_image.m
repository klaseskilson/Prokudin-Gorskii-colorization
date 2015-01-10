function [output] = reduce_image(input, accept_width)
% reduce_image(input, accept_width) - reduce image size until its width is 
%     less than a given value
%
% INPUT
%   input - the image to be resized
%   accept_width - (optional) the wanted width of the image
% 
% OUTPUT
%   output - the image

if nargin < 2
    accept_width = 300;
end

[h,w,l] = size(input);
output = input;

if w > accept_width
%     disp(['Width is ', num2str(w), ', reducing...']);
    % reduce size using gausian 
    output = impyramid(output, 'reduce');
    % make function call it self recursively
    output = reduce_image(output, accept_width);
end

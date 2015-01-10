function offset = align_image(image, reference, movement, step)
% Align image to reference, from -movement to movement in both x and y
% direction, and take step long steps.

switch nargin
    case 1
        error('too few arguments sent to align_images');
    case 2
        movement = 10;
        step = 1;
    case 3
        step = 1;
end;

best = 0;

for y_s = -movement:step:movement
    for x_s = -movement:step:movement
        % move images around
        tmp = circshift(image, [x_s y_s]);
        match = sum(sum(tmp.*reference));

        if match > best
            best = match;
            offset = [x_s y_s];
        end
    end
end

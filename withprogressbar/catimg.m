function img_cat = catimg(img, post_info)
%CATIMG concatenates the image stacks horizontally by default.

disp('---------------Concatenating the image sequence.----------------');
channel_num = numel(post_info.output_channel);

if channel_num == 1
    img_cat = img;
    return;
end

img_cat = [];
if channel_num > 1 && channel_num <= 4
    if channel_num == 2 || channel_num == 3
        for i_stack = 1:channel_num
            img_cat = [img_cat img(:,:,:, i_stack)];
        end
    else
        img_cat = [img(:,:,:, 1) img(:,:,:, 2); img(:,:,:, 3) img(:,:,:, 4)];
    end
else
    error('Error: cannot handle the channel over 4.');
end
disp('---------------Finish concatenation.----------------');
end
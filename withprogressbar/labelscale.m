function [img_scalebar, post_info_f] = labelscale(img, post_info)

disp('-----------------Labeling the scale bar-------------------');
scale = post_info.scale;
img_width = post_info.img_size(2);
img_height = post_info.img_size(1);
post_info_f = post_info;

%Evaluate the position and width of a scale bar.
right = round(0.028 * img_width); % dist of scalebar to right side
bot = round(0.046 * img_height); % dist of scalebar to bot side
bar_height = round(0.014 * img_height);
bar_width = round(0.18 * img_height);
real_bar_width = bar_width * scale;
real_bar_width = round(real_bar_width, -floor(log10(real_bar_width)));
bar_width = round(real_bar_width / scale);

%Insert the scale bar.
img_scalebar = img;
img_scalebar(end-bot-bar_height:end-bot, end-right-bar_width:end-right, :,:) = 255;

post_info_f.scalebar_um = real_bar_width; % um
end
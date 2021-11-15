function [imgScalebar, barInfo] = labelscale(img, postInfo)

disp('-----------------Labeling the scale bar-------------------');
scale = postInfo.scale;
[imgHeight, imgWidth] = deal(postInfo.compressedSize(1), postInfo.compressedSize(2));

%Evaluate the position and width of a scale bar.
right = round(0.028 * imgWidth); % dist of scalebar to right side
bot = round(0.046 * imgHeight); % dist of scalebar to bot side
barHeight = round(0.014 * imgHeight);
barWidth = round(0.18 * imgHeight);
realBarWidth = barWidth * scale;
realBarWidth = round(realBarWidth, -floor(log10(realBarWidth)));
barWidth = round(realBarWidth / scale);

%Insert the scale bar.
imgScalebar = img;
imgScalebar(end-bot-barHeight:end-bot, end-right-barWidth:end-right, :,:) = 255;

[barInfo.barHeight, barInfo.barWidth, barInfo.right, barInfo.bot, barInfo.scalebarUm] = deal(...
    barHeight, barWidth, right, bot, realBarWidth);
end
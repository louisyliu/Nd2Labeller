function [imgScalebar, barInfo] = labelscale(img, postInfo)

% disptitle('Labeling the scale bar');
scale = postInfo.scale;
[imgHeight, imgWidth] = deal(postInfo.compressedSize(1), postInfo.compressedSize(2));

%Evaluate the position and width of a scale bar.
% right = round(0.028 * imgWidth); % dist of scalebar to right side
right = round(0.04 * imgWidth);
bot = round(0.046 * imgHeight); % dist of scalebar to bot side
barHeight = round(0.014 * imgHeight);
barWidth = round(0.18 * imgWidth);
realBarWidth = barWidth * scale;
roundIdx = 10^(ceil(log10(realBarWidth)))/2;
realBarWidth = round(realBarWidth/roundIdx)*roundIdx;
if realBarWidth == 0
    realBarWidth = roundIdx/5;
end
barWidth = round(realBarWidth / scale);

%Insert the scale bar.
bgcolor = mean2(img(end-bot-barHeight:end-bot, end-right-barWidth:end-right, 1,:));
if bgcolor > 200
    barcolor = 0;
else
    barcolor = 255;
end
imgScalebar = img;
imgScalebar(end-bot-barHeight:end-bot, end-right-barWidth:end-right, :,:) = barcolor;

[barInfo.barHeight, barInfo.barWidth, barInfo.right, barInfo.bot, barInfo.scalebarUm, barInfo.barcolor] = deal(...
    barHeight, barWidth, right, bot, realBarWidth, barcolor);
end
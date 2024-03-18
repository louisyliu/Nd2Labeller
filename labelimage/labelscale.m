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
magnitude = floor(log10(realBarWidth));
firstDigit = floor(realBarWidth/10^(magnitude));

 % Determine the closest number starting with 1, 2, or 5
    if firstDigit <= 1
        realBarWidth = 10^magnitude;
    elseif firstDigit <= 2
        realBarWidth = 2 * 10^magnitude;
    elseif firstDigit <= 5
        realBarWidth = 5 * 10^magnitude;
    else
        realBarWidth = 10^(magnitude + 1);
    end

% realBarWidth = round(realBarWidth/roundIdx)*roundIdx;
% if realBarWidth == 0
%     realBarWidth = roundIdx/5;
% end
barWidth = round(realBarWidth / scale);

%Insert the scale bar.
bg = img(end-bot-barHeight:end-bot, end-right-barWidth:end-right, 1,:);
bgcolor = mean2(bg);

% if bgcolor > 200 
%     barcolor = 0;
% else
%     barcolor = 255;
% end
black = false;
white = false;
if all(bg(:)~= 0)
    black = true;
end
if all(bg(:)~=255)
    white = true;
end

if bgcolor < 200 && white
    barcolor = 255;
elseif black
    barcolor = 0;
end

imgScalebar = img;
imgScalebar(end-bot-barHeight:end-bot, end-right-barWidth:end-right, :,:) = barcolor;

[barInfo.barHeight, barInfo.barWidth, barInfo.right, barInfo.bot, barInfo.scalebarUm, barInfo.barcolor] = deal(...
    barHeight, barWidth, right, bot, realBarWidth, barcolor);
end
function imgTimeLabel = labeltimelabel(img, timeLabel)
%LABELTITLELABEL labels the image sequence with time label.
%   labeltimelabel(img, postInfo, timeLabel) labels the image sequence
%   [img] combined with multiple channels with the corresponding title in
%   [timeLabel], according to the info in [postInfo].  The labelled
%   position is on the top-right corner by default.

% compressedImg = postInfo.compressedSize;
% imgHeight = compressedImg(1);
% imgWidth = compressedImg(2);
nImg = size(img, 3);
imgTimeLabel = img;

[imgHeight, imgWidth] = size(img,[1 2]);

fontsize = round(30/720*max(size(img, 1:2))); % default 26 pt for 720 px
nLabels = min(nImg, size(timeLabel,1));

position = [round(0.007*imgWidth) imgHeight-round(0.007*imgHeight)];

bgcolor = mean2(img(position(2)-50:position(2), position(1):position(1)+50, 1));

if bgcolor > 200
    textcolor = 'black';
else
    textcolor = 'white';
end

timeLabel = sortrows(timeLabel);
frames = cell2mat(timeLabel(:,1));
if frames(1) ~= 1
    error('Error: The first frame of time label must be 1.');
end
if any(frames > nImg)
    error('Error: Frames of time labels are out of range.');
end
frames = [frames; nImg+1];
labelText = timeLabel(:,2);
for iLabel = 1:nLabels
    for iImg = frames(iLabel):frames(iLabel+1)-1
        RGB = insertText(img(:,:,iImg), position, labelText{iLabel}, 'Font', 'Lucida Console', ...
            'FontSize', fontsize, 'BoxOpacity', 0, 'TextColor', textcolor, 'AnchorPoint', 'LeftBottom');
        imgTimeLabel(:,:,iImg) = RGB(:,:,1);
    end
end

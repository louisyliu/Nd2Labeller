function imgCompressed = imgcompress(filename, postInfo, contrastMethod)
% Contrast method :
% 0: no contrast; 1: auto contrast; 2: manual contrast

scale = postInfo.resizeScale;
imgSize = postInfo.compressedSize;
frames = postInfo.frames;
nZStacks = size(frames, 2);
nXYStacks = size(frames, 1);
needRotate = false;
needCrop = false;
if isfield(postInfo, 'rotateAngle') && postInfo.rotateAngle ~= 0
    needRotate = true;
end

if isfield(postInfo, 'roiRect') && ~isempty(postInfo.roiRect)
    needCrop = true;
end
if postInfo.nChannels == 1
    exportedChannelNo = 1;
else
    exportedChannelNo = postInfo.exportedChannelNo;
end

nChannelStacks = numel(postInfo.exportedChannelNo);
nTime = postInfo.nTime;

% if isfield(postInfo, 'roiRect')
%     imgSize = round(postInfo.roiRect([4 3]));
%     needCrop = true;
% 
%     if min(imgSize) > shortestSide
%         scale = shortestSide/min(imgSize);
%         imgSize = ceil(imgSize*scale);
%     else
%         scale = 1;
%     end
% end

%Initialization
imgCompressed = zeros([imgSize nTime nChannelStacks nXYStacks nZStacks], 'uint8');

switch contrastMethod
    case 0
        lowhigh = repmat({repmat([0 1],numel(exportedChannelNo),1)}, nXYStacks, nZStacks);
    case 1
        lowhigh = postInfo.autoContrastPara;
    case 2
        lowhigh = postInfo.manualContrastPara;
    otherwise
        error('Wrong contrastMethod.');
end

f = Nd2Reader(filename);
stackNo = 0;
for iZ = 1:nZStacks
    for iXY = 1:nXYStacks
        icurrent = 0;
        stackNo = stackNo + 1;
        disptitle(['Compressing Img Stack {' num2str(stackNo) '}.']);
        processedFrame = frames{iXY, iZ};
        nProcessedFrame = numel(processedFrame);
        for iImg = processedFrame
            icurrent = icurrent + 1;
            img = f.getimage(iImg);
%             img = imresize(img, scale); 
            % Contrast stretch image
            currentChannel = 0;

            for iChannel = exportedChannelNo
                currentChannel = currentChannel + 1;
                imgProcessed = im2uint8(imadjust(img(:,:,iChannel), lowhigh{iXY, iZ}(currentChannel,:)));
                if needRotate
                    imgProcessed = imrotate(imgProcessed, postInfo.rotateAngle, 'bicubic', 'crop');
                end
                if needCrop
                    imgProcessed = imcrop(imgProcessed, postInfo.roiRect);
                end
                imgCompressed(:,:,icurrent, currentChannel, iXY, iZ) = imresize(imgProcessed, scale); % Resize the image
            end

            if numel(processedFrame) ~= 1
                dispbar(icurrent, nProcessedFrame);
            end
        end
    end
end

imgCompressed = squeeze(imgCompressed);
%Clear the file pointer.
f.close();
function imgCompressed = imgcompress(filename, postInfo, contrastMethod)
% Contrast method : 
% 0: no contrast; 1: auto contrast; 2: manual contrast

scale = postInfo.resizeScale;
imgSize = postInfo.compressedSize;
frames = postInfo.frames;
nZStacks = size(frames, 2);
nXYStacks = size(frames, 1);

if postInfo.nChannels == 1
    exportedChannelNo = 1;
else
    exportedChannelNo = postInfo.exportedChannelNo;
end

nChannelStacks = numel(postInfo.exportedChannelNo);
nTime = postInfo.nTime;

%Initialization
imgCompressed = zeros([imgSize nTime nChannelStacks nXYStacks nZStacks], 'uint8');

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
            img = imresize(img, scale); % Resize the image
            % Contrast stretch image
            currentChannel = 0;
            if contrastMethod == 1
                lowhigh = postInfo.autoContrastPara;
                for iChannel = exportedChannelNo
                    currentChannel = currentChannel + 1;
                    imgCompressed(:,:,icurrent, iChannel, iXY, iZ) = im2uint8(imadjust(img(:,:,iChannel), lowhigh{iXY, iZ}(currentChannel,:)));
                end
            elseif contrastMethod == 2
                lowhigh = postInfo.manualContrastPara;
                for iChannel = exportedChannelNo
                    currentChannel = currentChannel + 1;
                    imgCompressed(:,:,icurrent, iChannel, iXY, iZ) = im2uint8(imadjust(img(:,:,iChannel), lowhigh{iXY, iZ}(currentChannel,:)));
                end
            else
                for iChannel = exportedChannelNo
                    currentChannel = currentChannel + 1;
                    imgCompressed(:,:,icurrent, iChannel, iXY, iZ) = im2uint8(img(:,:,iChannel));
                end
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
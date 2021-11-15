function lowhigh = manualcontrastmovie(filename, varargin)

ImgInfo = nd2info(filename);
if nargin == 1
    frames = 1:ImgInfo.nImg;
    exportedChannelNo = 1;
elseif nargin == 2
    frames = varargin{1};
    exportedChannelNo = 1;
else
    frames = varargin{1};
    exportedChannelNo = varargin{2};
end

% Initialization
lowhigh = cell(frames);

f = Nd2Reader(filename);

for iXY = 1:size(frames, 1)
    for iZ = 1:size(frames, 2)
        frameStack = frames{iXY, iZ};
        im1 = im2double(f.getimage(frameStack(1)));
        im2 = im2double(f.getimage(frameStack(round(end/2))));
        im3 = im2double(f.getimage(frameStack(end)));
        
        currentChannel = 1;
        channelContrast = zeros(numel(exportedChannelNo), 2);
        for iChannel = exportedChannelNo
            [lowv1, highv1] = manualcontrast(im1);
            [lowv2, highv2] = manualcontrast(im2);
            [lowv3, highv3] = manualcontrast(im3);
            channelContrast(currentChannel,:) = [min([lowv1, lowv2, lowv3]) max([highv1, highv2, highv3])];
            currentChannel = currentChannel + 1;
        end
        lowhigh{iXY, iZ} = channelContrast;
    end
end

f.close();

end
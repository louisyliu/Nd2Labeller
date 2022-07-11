function lowhigh = manualcontrastmovie(filename, varargin)

f = Nd2Reader(filename);
nImg = f.getnimg;
frames = {1:nImg};
exportedChannelNo = 1;

if nargin >= 2
    frames = varargin{1};
end
if nargin >= 3
    exportedChannelNo = varargin{2};
end

% Initialization
lowhigh = cell(size(frames));

for iXY = 1:size(frames, 1)
    for iZ = 1:size(frames, 2)
        frameStack = frames{iXY, iZ};
        currentChannel = 1;
        channelContrast = zeros(numel(exportedChannelNo), 2);
        for iChannel = exportedChannelNo
            lowhightemp = adjustcontrastGUI(f, frameStack, iChannel).outputlowhigh();
            channelContrast(currentChannel,:) = lowhightemp;
            currentChannel = currentChannel + 1;
        end
        lowhigh{iXY, iZ} = channelContrast;
    end
end

f.close();
end


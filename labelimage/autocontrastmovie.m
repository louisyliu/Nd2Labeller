function lowhigh = autocontrastmovie(filename, varargin)

f = Nd2Reader(filename);
nImg = f.getnimg();

if nargin == 1
    frames = {1:nImg};
    exportedChannelNo = 1;
elseif nargin == 2
    frames = varargin{1};
    exportedChannelNo = 1;
else
    frames = varargin{1};
    exportedChannelNo = varargin{2};
end

% Initialization
lowhigh = cell(size(frames));

for iXY = 1:size(frames, 1)
    for iZ = 1:size(frames, 2)
        frameStack = frames{iXY, iZ};
        
        % Read images
        im1 = f.getimage(frameStack(1));
        im2 = f.getimage(frameStack(round(end/2)));
        im3 = f.getimage(frameStack(end));
        
        % Clear white border
        im1 = im1(6:end-5, 6:end-5, :);
        im2 = im2(6:end-5, 6:end-5, :);
        im3 = im3(6:end-5, 6:end-5, :);
        
        channelContrast = zeros(numel(exportedChannelNo), 2);
        
        for iChannel = 1:numel(exportedChannelNo)
            channel = exportedChannelNo(iChannel);
            
            % Calculate stretchlim
            v1 = stretchlim(im1(:,:,channel),0.0001);
            v2 = stretchlim(im2(:,:,channel),0.0001);
            v3 = stretchlim(im3(:,:,channel),0.0001);
            
            channelContrast(iChannel,:) = [min([v1, v2, v3], [], 'all') max([v1, v2, v3], [], 'all')];
        end
        
        lowhigh{iXY, iZ} = channelContrast;
    end
end

f.close();
end
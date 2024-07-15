function postInfo = nd2analysis(filename, objective, nFreqDiv, exportPara)
% Main function to analyze ND2 files

% Unpack export parameters
[exportedT, exportEveryNumFrame, exportedFreqNo, exportedXYNo, exportedZNo, exportedChannelNo] = ...
    deal(exportPara.exportedT, exportPara.exportEveryNumFrame, exportPara.exportedFreqNo, ...
    exportPara.exportedXYNo, exportPara.exportedZNo, exportPara.exportedChannelNo);

% Get image info and dimensions
ImgInfo = nd2info(filename);
timeSeqRaw = nd2time(filename);
Dimensions = ImgInfo.Dimensions;
nChannels = ImgInfo.nChannels;
nImg = ImgInfo.nImg;

% Prioritize objective from filename if available
if isfield(ImgInfo, 'objectiveFromFilename')
    objective = ImgInfo.objectiveFromFilename;
end

% Determine stack dimensions
[dimSize, exportedFreqNo, exportedT, exportedXYNo, exportedZNo, exportedChannelNo, exportInterval] = ...
    getstackdim(nFreqDiv, exportedFreqNo, exportedT, exportedChannelNo, exportedXYNo, exportedZNo, ...
    exportEveryNumFrame, Dimensions, nChannels, ImgInfo);

% Check dimension compatibility
if nFreqDiv > 1 && any(dimSize(2:end) > 1)
    error('Cannot handle "XY" "Z" "lambda" channels when channel splitter is used (nFreqdiv > 1)');
elseif sum(dimSize(2:end) > 1) > 2
    error('Cannot handle more than two of "XY" "Z" "lambda" channels.');
end

% Determine frames to export
if strcmp(Dimensions, 'N/A') % Single image
    exportedFrame{1} = 1;
    minFrame = 1;
else % Image stack
    if nFreqDiv > 1 % Frequency split
        exportedFrame = cell(numel(exportedFreqNo), 1);
        comparedSample = cell(numel(exportedFreqNo), 1);
        
        for i = 1:numel(exportedFreqNo)
            if isempty(exportedT)
                exportedFrame{i} = exportedFreqNo(i):exportInterval:nImg;
                comparedSample{i} = nd2read(filename, exportedFreqNo(i));
            else
                exportedFrame{i} = ceil((exportedT(1)-exportedFreqNo(i))/nFreqDiv)*nFreqDiv+exportedFreqNo(i):exportInterval:exportedT(2);
                comparedSample{i} = nd2read(filename, exportedFreqNo(i));
            end
        end
        
        minFrame = min(cellfun(@numel, exportedFrame));
        exportedFrame = cellfun(@(x) uint16(x(1:minFrame)), exportedFrame, 'UniformOutput', false);
        
        % Sort channels by intensity (largest first)
        intensity = cellfun(@(x) sum(x(:)), comparedSample);
        [~, iSort] = sort(intensity, 'descend');
        exportedFrame = exportedFrame(iSort);
    else % Multichannel
        exportedFrame = cell(numel(exportedXYNo), numel(exportedZNo));
        for iXY = 1:numel(exportedXYNo)
            for iZ = 1:numel(exportedZNo)
                if exportedT(1) == exportedT(end)
                    exportedFrame{iXY, iZ} = coordconvert(Dimensions, 'XY', exportedXYNo(iXY), 'Z', exportedZNo(iZ), 'T', exportedT(1));

                else
                    exportedFrame{iXY, iZ} = coordconvert(Dimensions, 'XY', exportedXYNo(iXY), 'Z', exportedZNo(iZ), 'T', exportedT(1):exportEveryNumFrame:exportedT(2));
                end
                exportedFrame{iXY, iZ} = exportedFrame{iXY, iZ}(exportedFrame{iXY, iZ} <= nImg);
            end
        end
        minFrame = min(cellfun(@numel, exportedFrame));
        exportedFrame = cellfun(@(x) uint16(x(1:minFrame)), exportedFrame, 'UniformOutput', false);
    end
end

% Get time sequence
if strcmp(Dimensions,'N/A')
    timeSeq{1} = 0;
else
    % timeSeq = cell(exportedFrame);
    % for iExportedFrameRow = 1:size(exportedFrame, 1)
    %     for iExportedFrameCol = 1:size(exportedFrame, 2)
    %         timeSeq{iExportedFrameRow, iExportedFrameCol} = timeSeqRaw(exportedFrame{iExportedFrameRow, iExportedFrameCol})/1000;
    %     end
    % end
    timeSeq = cellfun(@(x) timeSeqRaw(x)/1000, exportedFrame, 'UniformOutput', false);
end

% Auto contrast parameters
lowhigh = autocontrastmovie(filename, exportedFrame, exportedChannelNo);

% Populate postInfo structure
postInfo.objective = objective;
postInfo.nChannels = ImgInfo.nChannels;
postInfo.exportedChannelNo = exportedChannelNo;
postInfo.nTime = minFrame;
postInfo.timeSeq = timeSeq;
postInfo.frames = exportedFrame;
postInfo.autoContrastPara = lowhigh;
postInfo.name = ImgInfo.name;
postInfo.dimSize = dimSize;
postInfo.originalSize = [ImgInfo.height, ImgInfo.width];
postInfo.finalSize = [ImgInfo.height, ImgInfo.width];

if ImgInfo.nImg ~= 1
    postInfo.period = ImgInfo.period;
    postInfo.fps = ImgInfo.fps;
    postInfo.duration = ImgInfo.duration;
end
end

% Helper function to get stack dimensions
function [dimSize, exportedFreqNo, exportedT, exportedXYNo, exportedZNo, exportedChannelNo, exportInterval] = ...
    getstackdim(nFreqDiv, exportedFreqNo, exportedT, exportedChannelNo, exportedXYNo, exportedZNo, ...
    exportEveryNumFrame, Dimensions, nChannels, ImgInfo)

dimSize = zeros(4,1);
type = {Dimensions.type};
count = [Dimensions.count];
exportInterval = [];

if nFreqDiv > 1
    if isempty(exportedFreqNo)
        exportedFreqNo = 1:nFreqDiv;
    end
    dimSize(1) = length(exportedFreqNo);
    posFramesNo = contains(type, 'XY') | contains(type, 'Z');
    exportInterval = exportEveryNumFrame * nFreqDiv * prod(count(posFramesNo));
end

if isempty(exportedT)
    exportedT = [1 count(contains(type, 'T'))];
end

if any(contains(type, 'XY'))
    if isempty(exportedXYNo)
        exportedXYNo = 1:count(contains(type, 'XY'));
    end
else
    exportedXYNo = 1;
end
dimSize(2) = length(exportedXYNo);

if any(contains(type, 'Z'))
    if isempty(exportedZNo)
        exportedZNo = 1:count(contains(type, 'Z'));
    end
else
    exportedZNo = 1;
end
dimSize(3) = length(exportedZNo);

if nChannels > 1
    if isempty(exportedChannelNo)
        exportedChannelNo = 1:ImgInfo.nChannels;
    end
else
    exportedChannelNo = 1;
end
dimSize(4) = length(exportedChannelNo);
end
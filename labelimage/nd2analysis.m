function postInfo =  nd2analysis(filename, objective, nFreqDiv, exportPara)

% Main
[exportedT, exportEveryNumFrame, exportedFreqNo, exportedXYNo, exportedZNo, exportedChannelNo, shortestSideLength] ...
    = deal(exportPara.exportedT, exportPara.exportEveryNumFrame, exportPara.exportedFreqNo, exportPara.exportedXYNo, exportPara.exportedZNo,exportPara.exportedChannelNo, exportPara.shortestSideLength);

ImgInfo = nd2info(filename);
timeSeqRaw = nd2time(filename);
Dimensions = ImgInfo.Dimensions;
% if strcmp(Dimensions, 'N/A')
%
% end
% type = {Dimensions.type};
% count = [Dimensions.count];
% posFramesNo = contains(type, 'XY') | contains(type, 'Z');
% exportInterval = exportEveryNumFrame * nFreqDiv * prod(count(posFramesNo));
nImg = ImgInfo.nImg; % number of frames
if isfield(ImgInfo, 'objectiveFromFilename')
    objective = ImgInfo.objective;
end

temp = nd2read(filename, 1);
minSideLength = min(size(temp, 1:2));

if minSideLength <= shortestSideLength
    scale = 1;
else
    scale = shortestSideLength/minSideLength;
end
temp = imresize(temp, scale);

if strcmp(Dimensions, 'N/A')
    exportedFrame{1} = 1;
    minFrame = 1;
else
    type = {Dimensions.type};
    count = [Dimensions.count];
    posFramesNo = contains(type, 'XY') | contains(type, 'Z');
%     exportInterval = exportEveryNumFrame * nFreqDiv * prod(count(posFramesNo));
    % one channel (frequency division)
    if nFreqDiv > 1
        if isempty(exportedFreqNo)
            exportedFreqNo = 1:nFreqDiv;
        end
        
        exportInterval = exportEveryNumFrame * nFreqDiv * prod(count(posFramesNo));
        exportedFrame = cell(numel(exportedFreqNo), 1);
        comparedSample = cell(numel(exportedFreqNo), 1);
        for i = 1:numel(exportedFreqNo)
            if isempty(exportedT)
                exportedFrame{i} = exportedFreqNo(i):exportInterval:nImg;
                comparedSample{i} = nd2read(filename, exportedFreqNo(i));
            else
                exportedFrame{i} = ceil((exportedT(1)-exportedFreqNo(i))/nFreqDiv)*nFreqDiv+exportedFreqNo(i):exportInterval:exportedT(2);
                comparedSample{i} = nd2read(filename, exportedFreqNo(1));
            end
        end
        
        minFrame = min(cellfun(@numel, exportedFrame));
        exportedFrame = cellfun(@(x) uint16(x(1:minFrame)), exportedFrame, 'UniformOutput', 0);
        %     exportedFrame = uint16(cell2mat(exportedFrame));
        
        % Sort the channel by intensity. (largest the first)
        intensity = cellfun(@(x) sum(x(:)), comparedSample);
        [~, i_sort] = sort(intensity, 'descend');
        exportedFrame = exportedFrame(i_sort, :);
    else    % multichannel
        
        if isempty(exportedT)
            exportedT = [1 nImg];
        end
        
        if any(contains(type, 'XY'))
            if isempty(exportedXYNo)
                exportedXYNo = 1:count(contains(type, 'XY'));
            end
        else
            exportedXYNo = 1;
        end
        
        if any(contains(type, 'Z'))
            if isempty(exportedZNo)
                exportedZNo = 1:count(contains(type, 'Z'));
            end
        else
            exportedZNo = 1;
        end
        
        exportedFrame = cell(numel(exportedXYNo), numel(exportedZNo));
        for iXY = 1:numel(exportedXYNo)
            for iZ = 1:numel(exportedZNo)
%                 if verLessThan('matlab','9.7')
                    % -- Code to run in MATLAB R2019b and earlier here --
%                     exportedFrame{iXY, iZ} = coordconvert2019(Dimensions, exportedXYNo(iXY), exportedZNo(iZ), slice(1):exportInterval:slice(2));
%                 else
                    % -- Code to run in MATLAB R2019b and later here --
                    exportedFrame{iXY, iZ} = coordconvert(Dimensions, 'XY', exportedXYNo(iXY), 'Z', exportedZNo(iZ), 'T', exportedT(1):exportEveryNumFrame:exportedT(2));
%                 end
                
                exportedFrame{iXY, iZ}(exportedFrame{iXY, iZ} > nImg) = [];
            end
        end
        minFrame = min(cellfun(@numel, exportedFrame));
        exportedFrame = cellfun(@(x) uint16(x(1:minFrame)), exportedFrame, 'UniformOutput', 0);
    end
end

if strcmp(Dimensions,'N/A')
    timeSeq{1} = 0;
else
    timeSeq = cell(exportedFrame);
    for iExportedFrameRow = 1:size(exportedFrame, 1)
        for iExportedFrameCol = 1:size(exportedFrame, 2)
            timeSeq{iExportedFrameRow, iExportedFrameCol} = timeSeqRaw(exportedFrame{iExportedFrameRow, iExportedFrameCol})/1000;
        end
    end
end

% Auto contrast parameters.
if strcmp(Dimensions,'N/A')
    exportedChannelNo = 1;
elseif isempty(exportedChannelNo)
    exportedChannelNo = 1:ImgInfo.nChannels;
end
lowhigh = autocontrastmovie(filename, exportedFrame, exportedChannelNo);

% Info of compressed images.
postInfo.resizeScale = scale;  % Resized scale
postInfo.scale = 6.5/objective/scale;  % um/px
postInfo.period = ImgInfo.period;
postInfo.fps = ImgInfo.fps;
postInfo.duration = ImgInfo.duration;
postInfo.objectives = objective;
postInfo.nChannels = ImgInfo.nChannels;
postInfo.exportedChannelNo = exportedChannelNo;
postInfo.nTime = minFrame;
postInfo.timeSeq = timeSeq;
postInfo.compressedSize = size(temp, 1:2);  % compressed image size
postInfo.frames = exportedFrame;
postInfo.autoContrastPara = lowhigh;  % auto contrast parameter for imadjust
postInfo.name = ImgInfo.name;
end
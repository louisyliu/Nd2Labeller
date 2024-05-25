% parameters

disptitle('Loading Nd2 Data')
postInfo =  nd2analysis(filename, objective, nFreqDiv, exportPara);

% Adjust contrast
if processPara.contrastMethod == 2 % manual contrast
    disptitle('Loading manual contrast GUI')
    postInfo.manualContrastPara = manualcontrastmovie(filename, postInfo.frames, postInfo.exportedChannelNo);
elseif processPara.contrastMethod == 3 && ~isempty(processPara.contratPara)
    postInfo.manualContrastPara = processPara.contratPara; % defined contrast
end

% ROI
if processPara.drawROI == 1
    disptitle('Loading ROI selecting GUI')
    [postInfo.rotateAngle, postInfo.roiRect, postInfo.finalSize] = drawroiGUI(filename, postInfo, processPara.contrastMethod).getroi(); % [x y width height]
end

postInfo.gridImg = getgridsize(nFreqDiv, postInfo.dimSize, postInfo.finalSize); % grid size
postInfo = updateroiinfo(postInfo, exportPara.shortestSideLength);

% Export output info

% Compress image stack
imgCompressed = imgcompress(filename, postInfo, processPara.contrastMethod);

% Concatenate image stack
disptitle('Concatenating the image sequence');
imgCat = catimg2(imgCompressed, postInfo);

% Set font size 
fontsize = round(30/720*max(size(imgCat, 1:2))); % 30 pt for 720 px

% Stamp time
if processPara.needTimeStamp && postInfo.nTime > 1
    disptitle('Stamping time')
    imgTime = stamptime(imgCat, postInfo, startTime);
    %     imgTime = stamptime1(imgCat, postInfo.period,
    %     postInfo.duration,fontsize, startTime, postInfo.timeSeq{1}); % test
    %
else
    imgTime = imgCat;
end

% Label title
if ~isempty(processPara.title)
    disptitle('Labeling title')
    imgTitle = labeltitle(imgTime, postInfo, processPara.title);
else
    imgTitle = imgTime;
end

% Label time windows
if ~isempty(processPara.timeLabel)
    disptitle('Labeling time label')
    imgTimeLabel = labeltimelabel(imgTitle, processPara.timeLabel);
else
    imgTimeLabel = imgTime;
end

% Extract snapshot
if needSnapshot
    snapshot = imgsnap(imgTimeLabel, nSnap);
end

% Label scalebar
if processPara.needScalebar
    [imgScalebar, barInfo] = labelscale(imgTimeLabel, postInfo);
else
    imgScalebar = imgTime;
end

% Label text of scalebar
if processPara.needScaleText && postInfo.nTime > 1
    imgText = labelscaletext(imgScalebar, barInfo);
else
    imgText = imgScalebar;
end

% Convert img to movie
savename = [savedir '\' postInfo.name(1:end-4) '_scalebar' num2str(barInfo.scalebarUm) 'um'];
if strcmp(postInfo.duration, 'N/A') || size(imgTime, 3) == 1
    imwrite(imgText, [savename '.png']);
    disptitle('Successfully save the video in');
    disptitle([savename '.png']);
else
    im2movie(imgText, savename, frameRate, isCompressed);
end

% Snapshot labeling
if needSnapshot
    savesnapshot(snapshot, postInfo, processPara.title, savename);
end

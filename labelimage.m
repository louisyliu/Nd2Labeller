% Label image using low memory
disptitle('Loading Nd2 Data')
postInfo =  nd2analysis(filename, objective, nFreqDiv, exportPara);
disptitle('Finish Loading')

% Adjust contrast
if processPara.contrastMethod == 2 % manual contrast
    disptitle('Loading manual contrast GUI')
    postInfo.manualContrastPara = manualcontrastmovie(filename, postInfo.frames, postInfo.exportedChannelNo);
elseif processPara.contrastMethod == 3 && ~isempty(processPara.contratPara) % defined contrast
    postInfo.manualContrastPara = processPara.contratPara; % defined contrast
end

% ROI
if processPara.drawROI == 1
    disptitle('Loading ROI selection GUI')
    [postInfo.rotateAngle, postInfo.roiRect, postInfo.finalSize] = drawroiGUI(filename, postInfo, processPara.contrastMethod).getroi(); % [x y width height]
end

% Determine grid size
postInfo.gridImg = getgridsize(nFreqDiv, postInfo.dimSize, postInfo.finalSize); 
postInfo = updateroiinfo(postInfo, exportPara.shortestSideLength);

% Compress image stack
imgFinal = imgcompress(filename, postInfo, processPara.contrastMethod);

% Concatenate image stack
disptitle('Concatenating the image sequence');
imgFinal = catimg(imgFinal, postInfo);

% Set font size
fontsize = round(30/720*min(size(imgFinal, 1:2))); % default 26 pt for 720 px

% Stamp time
if processPara.needTimeStamp && postInfo.nTime > 1
    disptitle('Stamping time')
    imgFinal = stamptime(imgFinal, postInfo, startTime, fontsize);
end

% Label title
if ~isempty(processPara.title)
    disptitle('Labeling title')
    imgFinal = labeltitle(imgFinal, postInfo, processPara.title, fontsize);
end

% Label time label
if ~isempty(processPara.timeLabel)
    disptitle('Labeling time label')
    imgFinal = labeltimelabel(imgFinal, processPara.timeLabel, fontsize);
end

% Extract snapshot
if needSnapshot && postInfo.nTime > 1
    snapshot = imgsnap(imgFinal, nSnap);
end

% Label scalebar
if processPara.needScalebar
    [imgFinal, barInfo] = labelscale(imgFinal, postInfo);
end

% Label text of scalebar
if processPara.needScaleText && postInfo.nTime > 1
    imgFinal = labelscaletext(imgFinal, barInfo, fontsize);
end

% Convert img to .avi
if processPara.needScalebar
    savename = [savedir postInfo.name(1:end-4) '_scalebar' num2str(barInfo.scalebarUm) 'um'];
else
    savename = [savedir postInfo.name(1:end-4) '_noscalebar'];
end
if ~isempty(exportPara.exportedT)
    savename = [savename '_' num2str(exportPara.exportedT(1)) 'to' num2str(exportPara.exportedT(end))];
end

% Save video
if size(imgFinal, 3) == 1 || strcmp(postInfo.duration, 'N/A')
    imwrite(imgFinal, [savename '.png']);
    disptitle('Successfully save the image in');
    disptitle([savename '.png']);
else
    im2movie(imgFinal, savename, frameRate, isCompressed);
end

% Snapshot labeling
if needSnapshot
    savesnapshot(snapshot, postInfo, processPara.title, savename);
end

disptitle('Finished!')
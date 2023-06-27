% Label image using low memory
disptitle('Loading Nd2 Data')
postInfo =  nd2analysis(filename, objective, nFreqDiv, exportPara);
postInfo.autoContrastPara = {[0 0.1]; [0 0.03]};
disptitle('Finish Loading')
% Compress and contrast.
if processPara.contrastMethod == 2
    postInfo.manualContrastPara = manualcontrastmovie(filename, postInfo.frames, postInfo.exportedChannelNo);
end
if processPara.drawROI == 1
    [postInfo.rotateAngle, postInfo.roiRect, postInfo.cropSize] = drawroiGUI(filename, postInfo, processPara.contrastMethod).getroi(); % [x y width height]
    postInfo = updateroiinfo(postInfo, exportPara.shortestSideLength);
end
imgFinal = imgcompress(filename, postInfo, processPara.contrastMethod);
nImg = size(imgFinal, 3);
% Concatenate image stack
[imgFinal, postInfo] = catimg(imgFinal, postInfo);
% Stamp time
if processPara.needTimeStamp && nImg > 1
    disptitle('Stamping time')
    imgFinal = stamptime(imgFinal, postInfo, startTime);
end
% Extract snapshot
if needSnapshot
    snapshot = imgsnap(imgFinal, nSnap);
end
% Label title
if ~isempty(processPara.title)
    disptitle('Label title')
    imgFinal = labeltitle(imgFinal, postInfo, processPara.title);
end
% Label time label
if ~isempty(processPara.timeLabel)
    disptitle('Label time label')
    imgFinal = labeltimelabel(imgFinal, postInfo, processPara.timeLabel);
end
% Label scalebar
if processPara.needScalebar
    [imgFinal, barInfo] = labelscale(imgFinal, postInfo);
end
% Label text of scalebar
if processPara.needScaleText && nImg > 1
    imgFinal = labelscaletext(imgFinal, barInfo, postInfo);
end
%Convert img to .avi
if processPara.needScalebar
    savename = [savedir postInfo.name(1:end-4) '_scalebar' num2str(barInfo.scalebarUm) 'um'];
else
    savename = [savedir postInfo.name(1:end-4) '_noscalebar'];
end
if strcmp(postInfo.duration, 'N/A') || size(imgFinal, 3) == 1
    imwrite(imgFinal, [savename '.png']);
    disptitle('Successfully save the video in');
    disptitle([savename '.png']);
else
    im2movie(imgFinal, savename, frameRate, isCompressed);
end
% Snapshot labeling
if needSnapshot
    savesnapshot(snapshot, postInfo, processPara.title, savename);
end
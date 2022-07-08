% parameters
disptitle('Loading Nd2 Data')
postInfo =  nd2analysis(filename, objective, nFreqDiv, exportPara);
disptitle('Finish Loading')
% Compress and contrast.
if processPara.contrastMethod == 2
    postInfo.manualContrastPara = manualcontrastmovie(filename, postInfo.frames, postInfo.exportedChannelNo);
end
if processPara.drawROI == 1
    [postInfo.rotateAngle, postInfo.roiRect, postInfo.cropSize] = drawroiGUI(filename, postInfo, processPara.contrastMethod).getroi(); % [x y width height]
    postInfo = updateroiinfo(postInfo, exportPara.shortestSideLength);
end

imgCompressed = imgcompress(filename, postInfo, processPara.contrastMethod);
nImg = size(imgCompressed, 3);
% Concatenate image stack
imgCat = catimg(imgCompressed, postInfo);
% Stamp time
if processPara.needTimeStamp && nImg > 1
    disptitle('Stamping time')
    imgTime = stamptime(imgCat, postInfo, startTime);
else
    imgTime = imgCat;
end
% Label title
if ~isempty(processPara.title)
    disptitle('Label title')
    imgTitle = labeltitle(imgTime, postInfo, processPara.title);
else
    imgTitle = imgTime;
end
% Label scalebar
if processPara.needScalebar
    [imgScalebar, barInfo] = labelscale(imgTitle, postInfo);
else
    imgScalebar = imgTime;
end
% Label text of scalebar
if processPara.needScaleText && nImg > 1
    imgText = labelscaletext(imgScalebar, barInfo, postInfo);
else
    imgText = imgScalebar;
end
%Convert img to .avi
savename = [savedir '\' postInfo.name(1:end-4) '_scalebar' num2str(barInfo.scalebarUm) 'um'];
if strcmp(postInfo.duration, 'N/A') || size(imgTime, 3) == 1
    imwrite(imgText, [savename '.png']);
    disptitle('Successfully save the video in');
    disptitle([savename '.png']);
else
    videowrite(imgText, savename, frameRate, isCompressed);
end

% Need Snapshot
% if needSnapshot && nImg > 1
%     disptitle('Generating the snapshots');
%     iSnapshot = round(linspace(1,size(imgTime, 3)-10, nSnap));
%     icurrent = 0;
%     snapshot = cell(nSnap, 1);
%     for i = iSnapshot
%         icurrent = icurrent + 1;
%         if i == iSnapshot(end)
%             snapshot{icurrent} = labelscale(imgTime(:,:,i), postInfo);
%         else
%             snapshot{icurrent} = imgTime(:,:,i);
%         end
%     end
%     figure
%     montage(snapshot, 'ThumbnailSize', []);
%     axis off;
% 
% saveas(gcf, [savename '.png']);
% end
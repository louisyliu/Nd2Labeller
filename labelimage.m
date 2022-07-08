% Label image using low memory
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
imgFinal = imgcompress(filename, postInfo, processPara.contrastMethod);
nImg = size(imgFinal, 3);
% Concatenate image stack
imgFinal = catimg(imgFinal, postInfo);
% Stamp time
if processPara.needTimeStamp && nImg > 1
    disptitle('Stamping time')
    imgFinal = stamptime(imgFinal, postInfo, startTime);
end
% Label title
if ~isempty(processPara.title)
    disptitle('Label title')
    imgFinal = labeltitle(imgFinal, postInfo, processPara.title);
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
savename = [savedir postInfo.name(1:end-4) '_scalebar' num2str(barInfo.scalebarUm) 'um'];
if strcmp(postInfo.duration, 'N/A') || size(imgFinal, 3) == 1
    imwrite(imgFinal, [savename '.png']);
    disptitle('Successfully save the video in');
    disptitle([savename '.png']);
else
    videowrite(imgFinal, savename, frameRate, isCompressed);
end

% Snapshot
% if needSnapshot && nImg > 1
%     disptitle('Generating the snapshots');
%     iSnapshot = round(linspace(1,size(imgFinal, 3)-10, nSnap));
%     icurrent = 0;
%     snapshot = cell(nSnap, 1);
%     for i = iSnapshot
%         icurrent = icurrent + 1;
%         if i == iSnapshot(end)
%             snapshot{icurrent} = labelscale(imgFinal(:,:,i), postInfo);
%         else
%             snapshot{icurrent} = imgFinal(:,:,i);
%         end
%     end
%     figure
%     montage(snapshot, 'ThumbnailSize', []);
%     axis off;
%     saveas(gcf, [savename '.png']);
% end
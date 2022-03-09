% parameters
disptitle('Loading Nd2 Data')
postInfo =  nd2analysis(filename, objective, nFreqDiv, exportPara);
disptitle('Finish Loading')
% Compress and contrast.
if processPara.contrastMethod == 2
    postInfo.manualContrastPara = manualcontrastmovie(filename, postInfo.frames, postInfo.exportedChannelNo);
end

imgCompressed = imgcompress(filename, postInfo, processPara.contrastMethod);
nImg = size(imgCompressed, 3);
% Concatenate image stack
if processPara.isImgCombined
    imgCat = catimg(imgCompressed, postInfo);
else
    imgCat = imgCompressed;
end
% Stamp time
if processPara.hasTimeStamp && nImg > 1
    disptitle('Stamping time')
    imgTime = stamptime(imgCat, postInfo, startTime);
else
    imgTime = imgCat;
end
% Label scalebar
if processPara.hasScalebar
    [imgScalebar, barInfo] = labelscale(imgTime, postInfo);
else
    imgScalebar = imgTime;
end
% Label text of scalebar
if processPara.hasScaleText && nImg > 1
    imgText = labeltext(imgScalebar, barInfo);
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
if needSnapshot && nImg > 1
    disptitle('Generating the snapshots');
    iSnapshot = round(linspace(1,size(imgTime, 3)-10, nSnap));
    icurrent = 0;
    snapshot = cell(nSnap, 1);
    for i = iSnapshot
        icurrent = icurrent + 1;
        if i == iSnapshot(end)
            snapshot{icurrent} = labelscale(imgTime(:,:,i), postInfo);
        else
            snapshot{icurrent} = imgTime(:,:,i);
        end
    end
    figure
    montage(snapshot, 'ThumbnailSize', []);
    axis off;
end
saveas(gcf, [savename '.png']);
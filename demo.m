% parameters
disp('--------------Loading Nd2 Data------------------')
postInfo =  nd2analysis(filename, objective, nFreqDiv, exportPara);
disp('-----------------Finish Loading-----------------')
% Compress and contrast.
if processPara.isManualContrast
    postInfo.manualContrastPara = manualcontrastmovie(filename, postInfo.frames, postInfo.exportedChannelNo);
end
    
imgCompressed = imgcompress(filename, postInfo, processPara.isAutoContrast, processPara.isManualContrast);
% Concatenate image stack
if processPara.isImgCombined
    imgCat = catimg(imgCompressed, postInfo);
else
    imgCat = imgCompressed;
end
% Label scalebar
if processPara.hasScalebar
    [imgScalebar, barInfo] = labelscale(imgCat, postInfo);
else
    imgScalebar = imgCat;
end
% Label text of scalebar
if processPara.hasScaleText
    imgText = labeltext(imgScalebar, barInfo);
else
    imgText = imgScalebar;
end
% Stamp time
if processPara.hasTimeStamp
    imgTime = stamptime(imgText, postInfo);
else
    imgTime = imgText;
end
%Convert img to .avi
savename = [savedir '\' postInfo.name(1:end-4) '_scalebar' num2str(barInfo.scalebarUm) 'um'];
if strcmp(postInfo.duration, 'N/A') || size(imgTime, 3) == 1
    imwrite(imgTime, [savename '.png']);
    disp('----------Successfully save the video in ------------');
    disp(['----' savename '.png----']);
else
    img2avi(imgTime, savename, frameRate, isCompressed);
end

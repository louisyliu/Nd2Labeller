function imgTime = stamptime(img, postInfo)

[imgHeight, imgWidth, nImg] = size(img);
if nImg == 1
    imgTime = img;
    return
end
% fps = postInfo.final_fps;
% post_info_f = postInfo;
imgTime = img;

position = [round(0.007*imgWidth) round(0.007*imgHeight)];
duration = postInfo.duration;
period = postInfo.period; % s
timeSeq = postInfo.timeSeq{1};
timeSeq = timeSeq - timeSeq(1);
% Calculate the time interval (s)
if period < 1
    decimalNo = -floor(log10(period));
    period = round(period, 3);  % s
else
    decimalNo = 0;
    period = round(period,1);  % s
end
singleNo = floor(log10(duration))+1;


for iImg = 1:nImg
    
    
    timeStamp = timeSeq(iImg);
    
    % Evaluate time format
    if duration < 300 && period < 1
        % if period is shorter than 5 min.  format x.xx s.
        textStr = sprintf(['%' num2str(decimalNo + singleNo + 1) '.' num2str(decimalNo) 'f s'],  timeStamp);
    elseif duration < 3600
        % if period is shorter than 1 h.  format xx:xx (m:s).
        sec = floor(mod(timeStamp,60));
        min = floor(timeStamp/60);
        textStr = sprintf('%02d:%02d (m:s)',min, sec);
    else
        % if period is longer than 1 h.  format xx:xx:xx (h:m:s) or xx:xx (h:m).
        hour = floor(timeStamp/3600);
        remainer = mod(timeStamp,3600);
        min = floor(remainer/60);
        sec = floor(mod(remainer,60));
        if mod(round(period), 3600) == 0
            textStr = sprintf('%02d h',hour);
        elseif mod(round(period), 60) == 0
            textStr = sprintf('%02d:%02d (h:m)',hour, min);
        else
            textStr = sprintf('%02d:%02d:%02d (h:m:s)',hour, min, sec);
        end
    end
    
    RGB = insertText(imgTime(:,:,iImg),position,textStr,'Font','Lucida Console' ,'FontSize',26,'BoxOpacity', 0, 'TextColor','white');
    
    imgTime(:,:,iImg) = RGB(:,:,1);
    
    dispbar(iImg, nImg);
end

end
function imgTime = stamptime(img, postInfo, startTime)


imgSize = size(img);
imgHeight = imgSize(1);
imgWidth = imgSize(2);
nImg = imgSize(end);
% [imgHeight, imgWidth, nImg] = size(img);
if nImg == 1
    imgTime = img;
    return
end
% fps = postInfo.final_fps;
% post_info_f = postInfo;
imgTime = img;

position = [round(0.007*imgWidth) round(0.007*imgHeight)];
bgcolor = mean2(img(position(2):position(2)+50, position(1):position(1)+50,1));
if bgcolor > 200
    textcolor = 'black';
else
    textcolor = 'white';
end
duration = postInfo.duration;
period = postInfo.period; % s
timeSeq = postInfo.timeSeq{1};
timeSeq = timeSeq - timeSeq(1);
% Calculate the time interval (s)
if period < 1
    %     decimalNo = -floor(log10(period));
    decimalNo = 1;
    period = round(period, 3);  % s
else
    decimalNo = 0;
    period = round(period,1);  % s
end
singleNo = floor(log10(duration))+1;

fontsize = round(30/720*max(size(img, 1:2))); % default 26 pt for 720 px

for iImg = 1:nImg
    
    timeStamp = timeSeq(iImg)+startTime;

    % Evaluate time format
    if duration < 300 && period < 1
        % if period is shorter than 5 min.  format x.xx s.
        textStr = sprintf(['%' num2str(decimalNo + singleNo + 1) '.' num2str(decimalNo) 'f s'],  timeStamp);
    elseif duration < 3600
        % if period is shorter than 1 h.  format xx:xx (m:s).
        sec = floor(mod(timeStamp,60));
        minute = floor(timeStamp/60);
        textStr = sprintf('%02d:%02d (m:s)',minute, sec);
    else
        % if period is longer than 1 h.  format xx:xx:xx (h:m:s) or xx:xx (h:m).
        hour = floor(timeStamp/3600);
        remainer = mod(timeStamp,3600);
        minute = floor(remainer/60);
        sec = floor(mod(remainer,60));

        % period is unit of second
        if period > 1 && mod(round(period), 3600) == 0 % period > 1 in case of fast time lapse for 1h
            textStr = sprintf('%02d h',hour);
        elseif period > 1 && mod(round(period), 60) == 0 
            textStr = sprintf('%02d:%02d (h:m)',hour, minute);
        else
            textStr = sprintf('%02d:%02d:%02d (h:m:s)',hour, minute, sec);
        end
    end

    RGB = insertText(imgTime(:,:,iImg),position,textStr,'Font','Lucida Console' ,'FontSize',fontsize,'BoxOpacity', 0, 'TextColor',textcolor);

    imgTime(:,:,iImg) = RGB(:,:,1);

    %     dispbar(iImg, nImg);
end

end
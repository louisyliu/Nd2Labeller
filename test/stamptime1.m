function imgTime = stamptime1(img, interval, duration, fontsize, startTime, timeSeq)
%STAMPTIME stamps time in the left-top corner of movie.
%   [img] : movie of 3-D array that is ready to stamp time. 
%   [interval]: time interval for each frame. unit: s
%   [duration]: duration of the movie.  unit: s
%   [fontsize]: font size.  A suitiable size is 30 pt for 720 px x 720 px.
%   [startTime]: (option) displayed starting time of the movie.  0 by
%       default.
%   [timeSeq]: (option) time sequence of the movie, read from .nd2 file. If
%       timeSeq is missing, the dispalyed time follows the equal interval. 
%
%   Usage:
%       imgTime = stamptime1(img, interval, duration)
%       imgTime = stamptime1(img, interval, duration, startTime)
%       imgTime = stamptime1(img, interval, duration, startTime, timeSeq)

if nargin < 6
    timeSeq = 0:interval:duration/interval;
end
if nargin < 5
    startTime = 0;
end

% if nargin == 2
%     startTime = 0; % startTime: s.
% elseif nargin == 3
%     startTime = varargin{1};
% end

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
bgcolor = mean2(img(position(1):position(1)+50, position(2):position(2)+50,1));
if bgcolor > 200
    textcolor = 'black';
else
    textcolor = 'white';
end
% duration = postInfo.duration;
% interval = postInfo.interval; % s
% timeSeq = postInfo.timeSeq{1};
timeSeq = timeSeq - timeSeq(1);
% Calculate the time interval (s)
if interval < 1
    %     decimalNo = -floor(log10(interval));
    decimalNo = 1;
    interval = round(interval, 3);  % s
else
    decimalNo = 0;
    interval = round(interval,1);  % s
end
singleNo = floor(log10(duration))+1;

% fontsize = round(30/720*max(postInfo.compressedSize)); % default 26 pt for 720 px

for iImg = 1:nImg
    
    timeStamp = timeSeq(iImg)+startTime;

    % Evaluate time format
    if duration < 300 && interval < 1
        % if interval is shorter than 5 min.  format x.xx s.
        textStr = sprintf(['%' num2str(decimalNo + singleNo + 1) '.' num2str(decimalNo) 'f s'],  timeStamp);
    elseif duration < 3600
        % if interval is shorter than 1 h.  format xx:xx (m:s).
        sec = floor(mod(timeStamp,60));
        minute = floor(timeStamp/60);
        textStr = sprintf('%02d:%02d (m:s)',minute, sec);
    else
        % if interval is longer than 1 h.  format xx:xx:xx (h:m:s) or xx:xx (h:m).
        hour = floor(timeStamp/3600);
        remainer = mod(timeStamp,3600);
        minute = floor(remainer/60);
        sec = floor(mod(remainer,60));
        if mod(round(interval), 3600) == 0
            textStr = sprintf('%02d h',hour);
        elseif mod(round(interval), 60) == 0
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
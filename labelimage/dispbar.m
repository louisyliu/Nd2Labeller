function dispbar(iLoop, nLoops)
%DISPBAR displays progress bar in for loop.
%   iLoop = current loop.    nLoops = total number of loops
%   Usage:
%       for i = 1:nLoops
%           TODO
%           dispbar(i, nLoops);
%       end

% Attributes
finishLabel = '>';  % '>' by default
unfinishLabel = '-'; %  '-' by default
barLength = 50; % 50 is fine.

% Main
nFinishLabel = floor(iLoop/nLoops*barLength);
c = clock; % [year month day hour minute seconds]
formatTime = sprintf('%02d:%02d:%02d ',c(4),c(5),round(c(6))); % format current time.
% allInfoLength = 65 + barLength;

if iLoop ~= nLoops
    preText = sprintf('Processing [');
    barLabel = sprintf([repmat(finishLabel, 1, nFinishLabel) repmat(unfinishLabel, 1, barLength-nFinishLabel)]);
    percentageText = sprintf('] %4.1f%%', iLoop/nLoops*100);
    if iLoop ~= 1
        runTime = toc;
        remainingTime = runTime/(iLoop-1)*(nLoops-1) - runTime;
        %     if remainingTime > 3600
        h = floor(remainingTime/3600);
        m = floor(mod(remainingTime,3600)/60);
        s = round(mod(mod(remainingTime,3600),60));
        remainingTimeText = sprintf(' %2d h %2d min %2d s remaining...', h, m, s);
    else
        remainingTimeText = ' Estimating the remaining time';
    end
    showText = [formatTime preText barLabel percentageText remainingTimeText];
else
    showText = sprintf([formatTime 'Finish! 100%%         Time used: ' num2str(toc/(nLoops-1)*nLoops) ' s\n']);
end

% Safe for percent character and backslash
showText = strrep(showText,'%','%%');
showText = strrep(showText,'\','\\');



if iLoop == 1
    tic;
    nDelete = 0;
else
    nDelete = 108;
end

% Print progress bar.
fprintf([repmat('\b', 1, nDelete) showText]);

end
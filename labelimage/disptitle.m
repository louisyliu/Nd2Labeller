function disptitle(str)
%DISPTITLE Displays the title with equally distributed bars.
totLength = 80;
strLength = length(str);
if strLength < 80
    prebarLength = floor((totLength - strLength)/2);
    postbarLength = totLength - strLength - prebarLength;
    prebar = sprintf(repmat('-', 1, prebarLength));
    postbar = sprintf(repmat('-', 1, postbarLength));
    fulltext = [prebar str postbar];
else
    fulltext = str;
end
disp(fulltext);
end


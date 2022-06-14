function imgTitle = labeltitle(img, postInfo, title)

compressedImg = postInfo.compressedSize;
imgHeight = compressedImg(1);
imgWidth = compressedImg(2);
nImg = size(img, 3);
% [imgHeight, imgWidth, nImg] = size(img);
if nImg == 1
    imgTitle = img;
    return
end
% fps = postInfo.final_fps;
% post_info_f = postInfo;
imgTitle = img;

% position = [imgWidth-round(0.007*imgWidth) imgHeight-round(0.007*imgHeight)];
% bgcolor = mean2(img(position(1):position(1)+50, position(2):position(2)+50,1));
% if bgcolor > 200
%     textcolor = 'black';
% else
%     textcolor = 'white';
% end

fontsize = round(30/720*max(postInfo.compressedSize)); % default 26 pt for 720 px
nTitle = min(length(postInfo.frames), length(title));
if length(title) > nTitle 
    title = title(1:nTitle);
end
textcolor = cell(nTitle, 1);

position = [imgWidth*(1:nTitle)'-round(0.007*imgWidth) round(0.007*imgHeight)*ones(nTitle, 1)];
for iTitle = 1:nTitle
    bgcolor = mean2(img(position(iTitle,1):position(1)-50, position(iTitle,2):position(2)-50,1));
    if bgcolor > 200
        textcolor{iTitle} = 'black';
    else
        textcolor{iTitle} = 'white';
    end
end

for iImg = 1:nImg
    RGB = insertText(imgTitle(:,:,iImg),position,title,'Font','Lucida Console' ,'FontSize',fontsize,'BoxOpacity', 0, 'TextColor',textcolor, 'AnchorPoint','RightTop');
    imgTitle(:,:,iImg) = RGB(:,:,1);
    %     dispbar(iImg, nImg);
end

end
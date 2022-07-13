function imgTitle = labeltitle(img, postInfo, titles)
%LABELTITLE labels the image sequence with titles.
%   labeltitle(img, postInfo, title) labels the image sequence [img] combined
%   with multiple channels with the corresponding title in [titles],
%   according to the info in [postInfo].  The labelled position is on the
%   top-right corner by default. 

compressedImg = postInfo.compressedSize;
imgHeight = compressedImg(1);
imgWidth = compressedImg(2);
nImg = size(img, 3);
imgTitle = img;



fontsize = round(30/720*max(postInfo.compressedSize)); % default 26 pt for 720 px
nTitle = min(length(postInfo.frames)*numel(postInfo.exportedChannelNo), length(titles));
if length(titles) > nTitle 
    titles = titles(1:nTitle);
end
textcolor = cell(nTitle, 1);
position = [];
nGridX = postInfo.gridImg(1);
for iGridY = 1:postInfo.gridImg(2)
    position = [position; imgWidth*(1:nGridX)'-round(0.007*imgWidth) round(0.007*imgHeight)*ones(nGridX, 1) + (iGridY-1)*imgHeight];
end
% position1 = [imgWidth*(1:nTitle)'-round(0.007*imgWidth) round(0.007*imgHeight)*ones(nTitle, 1)]; 
% position2 = [imgWidth*(1:nTitle)'-round(0.007*imgWidth) round(0.007*imgHeight)*ones(nTitle, 1) + imgHeight]; 
% position = [position1; position2];
for iTitle = 1:nTitle
    bgcolor = mean2(img(position(iTitle,2):position(iTitle,2)+50, (position(iTitle,1)-50):position(iTitle,1), 1));
    if bgcolor > 200
        textcolor{iTitle} = 'black';
    else
        textcolor{iTitle} = 'white';
    end
end

for iImg = 1:nImg
    RGB = insertText(imgTitle(:,:,iImg),position(1:nTitle, :), titles(1:nTitle),'Font','Lucida Console' ,'FontSize',fontsize,'BoxOpacity', 0, 'TextColor',textcolor(1:nTitle), 'AnchorPoint','RightTop');
    imgTitle(:,:,iImg) = RGB(:,:,1);
end

end
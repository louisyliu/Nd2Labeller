function [postInfo] = updateroiinfo(postInfo, shortestSideLength)
% update scale and imgSize after selecting roi.

postInfo.compressedSize = postInfo.cropSize;
shortestSide = min(postInfo.compressedSize);
if shortestSide > shortestSideLength
    postInfo.resizeScale = shortestSideLength/shortestSide;
    postInfo.compressedSize = ceil(postInfo.compressedSize*postInfo.resizeScale);
else 
    postInfo.resizeScale = 1;
end
postInfo.scale = 6.5/postInfo.objective/postInfo.resizeScale;  % um/px
end
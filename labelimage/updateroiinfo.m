function [postInfo] = updateroiinfo(postInfo, shortestSideLength)
% update scale and imgSize after selecting roi.

totSize = postInfo.finalSize.*postInfo.gridImg;
[shortestSide] = min(totSize);
if shortestSide > shortestSideLength
    postInfo.resizeScale = shortestSideLength/shortestSide;
else
    postInfo.resizeScale = 1;
end
postInfo.finalSize = ceil(postInfo.finalSize*postInfo.resizeScale);

postInfo.scale = 6.5/postInfo.objective/postInfo.resizeScale;  % um/px
end
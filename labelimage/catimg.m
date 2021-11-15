function imgCat = catimg(img, postInfo)

%CATIMG concatenates the image stacks horizontally by default.

disp('---------------Concatenating the image sequence.----------------');

if postInfo.nTime == 1
    dimHorizontal = 3;
else
    dimHorizontal = 4;
end
dimVertical = dimHorizontal+1;

nDimHorizontal = size(img, dimHorizontal);
nDimVertical = size(img, dimVertical);

if nDimHorizontal < nDimVertical
    [dimHorizontal, dimVertical] = deal(dimVertical,dimHorizontal);
end

imgCat = [];

if postInfo.nTime == 1
    
    if size(img, dimVertical) == 1 % only 1D.
        for iDimHorizontal = 1:size(img,dimHorizontal)
            imgCat = [imgCat img(:,:, iDimHorizontal)];
        end
    else
        for iDimVertical = 1:size(img, dimVertical)
            tempCat = [];
            for iDimHorizontal = 1:size(img, dimHorizontal)
                tempCat = [tempCat img(:,:, iDimHorizontal, iDimVertical)];
            end
            imgCat = [imgCat; tempCat];
        end
    end
    
else
    if size(img, dimVertical) == 1 % only 1D.
        for iDimHorizontal = 1:size(img,dimHorizontal)
            imgCat = [imgCat img(:,:,:, iDimHorizontal)];
        end
    else
        for iDimVertical = 1:size(img, dimVertical)
            tempCat = [];
            for iDimHorizontal = 1:size(img, dimHorizontal)
                if dimHorizontal < dimVertical
                    tempCat = [tempCat img(:,:,:, iDimHorizontal, iDimVertical)];
                else
                    tempCat = [tempCat img(:,:,:, iDimVertical,iDimHorizontal)];
                end
            end
            imgCat = [imgCat; tempCat];
        end
    end
end

disp('---------------Finish concatenation.----------------');
end
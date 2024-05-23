function [imgCat, postInfo] = catimg2(img, postInfo)
% CATIMG2 concatenates the image stacks horizontally or vertically based on the grid size.
%
% Inputs:
%   - img: Input image stack.
%   - postInfo: Structure containing grid size and time information.
%
% Outputs:
%   - imgCat: Concatenated image stack.
%   - postInfo: Structure containing grid size and time information (unchanged).

disptitle('Concatenating the image sequence.');

imgSize = size(img);
gridSize = postInfo.gridImg;
nRows = gridSize(1);
nCols = gridSize(2);
nTime = postInfo.nTime;

if nTime == 1
    % Single time point
    if nRows > 1 && nCols > 1
        % Multiple rows and columns
        imgCat = zeros(nRows * imgSize(1), nCols * imgSize(2), 'like', img);
        for i = 1:nRows
            for j = 1:nCols
                if imgSize(3) == nCols
                    imgCat((i-1)*imgSize(1)+1:i*imgSize(1), (j-1)*imgSize(2)+1:j*imgSize(2)) = img(:,:,j,i);
                else
                    imgCat((i-1)*imgSize(1)+1:i*imgSize(1), (j-1)*imgSize(2)+1:j*imgSize(2)) = img(:,:,i,j);
                end
            end
        end
    elseif nRows > 1
        % Multiple rows, single column
        imgCat = zeros(nRows * imgSize(1), imgSize(2), 'like', img);
        for i = 1:nRows
            imgCat((i-1)*imgSize(1)+1:i*imgSize(1), :) = img(:,:,i);
        end
    elseif nCols > 1
        % Single row, multiple columns
        imgCat = zeros(imgSize(1), nCols * imgSize(2), 'like', img);
        for i = 1:nCols
            imgCat(:, (i-1)*imgSize(2)+1:i*imgSize(2)) = img(:,:,i);
        end
    else
        % Single image, no concatenation needed
        imgCat = img;
    end
else
    % Multiple time points
    if nRows > 1 && nCols > 1
        % Multiple rows and columns
        imgCat = zeros(nRows * imgSize(1), nCols * imgSize(2), imgSize(3), 'like', img);
        for i = 1:nRows
            for j = 1:nCols
                if length(imgSize) >= 5 && imgSize(4) == nCols
                    imgCat((i-1)*imgSize(1)+1:i*imgSize(1), (j-1)*imgSize(2)+1:j*imgSize(2), :) = img(:,:,:,j,i);
                else
                    imgCat((i-1)*imgSize(1)+1:i*imgSize(1), (j-1)*imgSize(2)+1:j*imgSize(2), :) = img(:,:,:,i,j);
                end
            end
        end
    elseif nRows > 1
        % Multiple rows, single column
        imgCat = zeros(nRows * imgSize(1), imgSize(2), imgSize(3), 'like', img);
        for i = 1:nRows
            imgCat((i-1)*imgSize(1)+1:i*imgSize(1), :, :) = img(:,:,:,i);
        end
    elseif nCols > 1
        % Single row, multiple columns
        imgCat = zeros(imgSize(1), nCols * imgSize(2), imgSize(3), 'like', img);
        for i = 1:nCols
            imgCat(:, (i-1)*imgSize(2)+1:i*imgSize(2), :) = img(:,:,:,i);
        end
    else
        % Single image, no concatenation needed
        imgCat = img;
    end
end
end
function gridSize = getgridsize2(nFreqDiv, dimSize, imgSize)
% GETGRIDSIZE2 calculates the optimal grid size based on the number of frequency divisions,
% dimension sizes, and image size.
%
% Inputs:
%   - nFreqDiv: Number of frequency divisions.
%   - dimSize: Size of each dimension.
%   - imgSize: Size of the image.
%
% Output:
%   - gridSize: Optimal grid size [nRow nCol].

optimalAR = 2; % Optimal aspect ratio
aspectRatio = imgSize(2) / imgSize(1);

nRow = 1;
nCol = 1;

if nFreqDiv > 1 && dimSize(1) ~= 1
    nRow = dimSize(1);
else
    idx = find(dimSize(2:end) > 1, 2);
    nDims = length(idx);
    if nDims >= 1
        nRow = dimSize(idx(1) + 1);
        if nDims > 1
            nCol = dimSize(idx(2) + 1);
        end
    end
end

const1 = nCol / nRow;
scaleRow = aspectRatio * const1 / optimalAR;
scaleCol = aspectRatio / const1 / optimalAR;

if scaleRow < 1
    scaleRow = 1 / scaleRow;
end
if scaleCol < 1
    scaleCol = 1 / scaleCol;
end

if scaleRow > scaleCol
    [nCol, nRow] = deal(nRow, nCol);
end

gridSize = [nRow nCol];
end
function lowhigh = autocontrastmovie(filename, varargin)

imgInfo = ND2Info(filename);
if nargin == 1
    frames = 1:imgInfo.numImages;
else
    frames = varargin{1};
end
% Initialization 
lowhigh = zeros(size(frames, 1), 2);

[FilePointer, ImagePointer, ImageReadOut] = ND2Open(filename);

for istack = 1:size(frames, 1)
    im1 = ND2Read(FilePointer, ImagePointer, ImageReadOut, frames(istack, 1));
    im2 = ND2Read(FilePointer, ImagePointer, ImageReadOut, frames(istack, round(end/2)));
    im3 = ND2Read(FilePointer, ImagePointer, ImageReadOut, frames(istack, end));
    % Clear white border.
    im1 = im1(6:end-5, 6:end-5);
    im2 = im2(6:end-5, 6:end-5);
    im3 = im3(6:end-5, 6:end-5);
    
    v1 = stretchlim(im1,0.0001);
    v2 = stretchlim(im2,0.0001);
    v3 = stretchlim(im3,0.0001);
    lowhigh(istack, :) = [min([v1, v2, v3], [], 'all') max([v1, v2, v3], [], 'all')];
end

% Clear the file pointer.
ND2Close(FilePointer)
clear('FilePointer')

end
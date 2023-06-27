function im2movie(img, savename, framerate, isCompressed)

if isCompressed
    v = VideoWriter(savename, 'MPEG-4');
    v.Quality = 100;
else
    v = VideoWriter(savename, 'Grayscale AVI');
% v = VideoWriter(savename, 'Uncompressed AVI');
end

v.FrameRate = framerate;

open(v);
imgDim = ndims(img);
nImg = size(img, imgDim);
disptitle('Converting IMG to AVI')
for iImg = 1:nImg
    if imgDim == 3
        writeVideo(v, img(:,:,iImg));
    elseif imgDim == 4
        writeVideo(v, mat2gray(img(:,:,:,iImg)));
    end
    %     dispbar(iImg, nImg);
end

disptitle('Successfully save the video in ')
disptitle([savename '.' v.FileFormat])
close(v);
end
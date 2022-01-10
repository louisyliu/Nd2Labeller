function img2avi(img, savename, framerate, isCompressed)

if isCompressed
    v = VideoWriter(savename, 'MPEG-4');
    v.Quality = 100;
else
    v = VideoWriter(savename, 'Grayscale AVI');
end

v.FrameRate = framerate;

open(v);
nImg = size(img, 3);
disptitle('Converting IMG to AVI')
for iImg = 1:nImg
    writeVideo(v, img(:,:,iImg));
%     dispbar(iImg, nImg);
end

disptitle('Successfully save the video in ')
disptitle([savename '.' v.FileFormat])
close(v);
end
function img2avi(img, savename)

v = VideoWriter(savename, 'MPEG-4');
v.FrameRate = 60;
v.Quality = 75;

open(v);
num_img = size(img, 3);
disp('-----------------Converting IMG to AVI---------------------')
for i_img = 1:num_img
    writeVideo(v, img(:,:,i_img));
    dispbar(i_img, num_img);
end
close(v);
end
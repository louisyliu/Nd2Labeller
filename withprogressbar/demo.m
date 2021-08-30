
filedir = 'G:\project\20210815_lattice_inG5\';
file = 'G5inlargerpetridish_6min';
savedir = 'G:\project_processed\';

filename = [filedir file '.nd2'];

%Analize ND2 file
post_info =  ND2Analysis(filename, 4, 4, 2, [1 2]);
%Split and compress the images
img_compressed = ND2Compressor_new(filename, post_info);
%Concatenate image stack
img_cat = catimg(img_compressed, post_info);
%Label scalebar
[img_scalebar, post_info] = labelscale(img_cat, post_info);
%Stamp time
[img_time, post_info] = stamptime(img_scalebar, post_info);
%Convert img to .avi
savename = [savedir file '_scalebar' num2str(post_info.scalebar_um) 'um_' num2str(post_info.final_fps) 'fps'];
img2avi(img_time, savename);
function img_compressed = ND2Compressor_new(filename, post_info)

scale = post_info.resize_scale;
img_size = post_info.img_size;
frames = post_info.frames;
img_num = size(frames, 2);

%Initialization
img_compressed = zeros([img_size size(frames, 2) size(frames, 1)], 'uint8');

[FilePointer, ImagePointer, ImageReadOut] = ND2Open(filename);

%Find limits to contrast stretch image
lowhigh = [];
for istack = 1:size(frames, 1)
    im1 = ND2Read(FilePointer, ImagePointer, ImageReadOut, frames(istack, 1));
    im2 = ND2Read(FilePointer, ImagePointer, ImageReadOut, frames(istack, end/2));
    im3 = ND2Read(FilePointer, ImagePointer, ImageReadOut, frames(istack, end));
    v1 = stretchlim(im1,0.0001);
    v2 = stretchlim(im2,0.0001);
    v3 = stretchlim(im3,0.0001);
    lowhigh = [lowhigh; min([v1, v2, v3], [], 'all') max([v1, v2, v3], [], 'all')];
end

for istack = 1:size(frames, 1)
    icurrent = 0;
    disp(['-------------Img ' num2str(istack) ' is being compressed.------------']);
    for iimg = frames(istack, :)
        icurrent = icurrent + 1;
        img = ND2Read(FilePointer, ImagePointer, ImageReadOut, iimg);
        img = imresize(img, scale); %Resize the image
        %Contrast stretch image
        img_compressed(:,:,icurrent, istack) = im2uint8(imadjust(img, lowhigh(istack, :)));
        dispbar(icurrent, img_num);
    end
end

%Clear the file pointer.
ND2Close(FilePointer)
clear('FilePointer')
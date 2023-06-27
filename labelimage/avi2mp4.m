function avi2mp4(filename, quality)
if nargin == 1
    quality = 100;
end
[filepath,name,~] = fileparts(filename);
in = VideoReader(filename);
savename = fullfile(filepath, name);
out = VideoWriter(savename,'MPEG-4');
out.Quality = quality;
out.FrameRate = in.FrameRate;
open(out)
while hasFrame(in)
    frame = readFrame(in);
    writeVideo(out,frame);
end

close(out)
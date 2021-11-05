function avi2mp4(filename)
[filepath,name,~] = fileparts(filename);
in = VideoReader(filename);
savename = fullfile(filepath, name);
out = VideoWriter(savename,'MPEG-4');
out.Quality = 75;
out.FrameRate = 40;
open(out)
while hasFrame(in)
    frame = readFrame(in);
    writeVideo(out,frame);
end

close(out)
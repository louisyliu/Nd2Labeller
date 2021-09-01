function post_info =  ND2Analysis(filename, obj, varargin)

switch nargin
    case 2
        output_every_frame = 1;
        slice = [];
        split_channel_num = 1;
        output_channel = 1;
        shortest_side = 720;
    case 3
        output_every_frame =  varargin{1};
        slice = [];
        split_channel_num = 1;
        output_channel = 1;
        shortest_side = 720;
    case 4
        output_every_frame =  varargin{1};
        slice = varargin{2};
        split_channel_num = 1;
        output_channel = 1;
        shortest_side = 720;
    case 5
        output_every_frame =  varargin{1};
        slice = varargin{2};
        split_channel_num = varargin{3};
        output_channel = 1;
        shortest_side = 720;
    case 6
        output_every_frame =  varargin{1};
        slice = varargin{2};
        split_channel_num = varargin{3};
        output_channel = varargin{4};
        shortest_side = 720;
    case 7
        output_every_frame =  varargin{1};
        slice = varargin{2};
        split_channel_num = varargin{3};
        output_channel = varargin{4};
        shortest_side = varargin{5};
    otherwise
        error('Error: Number of argument is out of range. ')
end

interval = output_every_frame * split_channel_num;
imgInfo = ND2Info(filename);
img_num = imgInfo.numImages; % number of frames of movie

if imgInfo.Experiment.parameters.durationMs == 0 % fast time lapse
    period_original = imgInfo.Experiment.parameters.periodDiff.avg/1000; % unit s
    fps_original = round(1/period_original);
else % ND acquisition
    period_original = imgInfo.Experiment.parameters.periodMs/1000;
    fps_original = 1/period_original;
end

output_fps = fps_original / interval; % output fps
period_final = period_original * interval;
temp = ND2ReadSingle(filename, 1);
min_size = min(size(temp));

if min_size <= shortest_side
    scale = 1;
else
    scale = shortest_side/min_size;
end
temp = imresize(temp, scale);

%Ensure frame number of each channel are the same.
exported_frame = cell(numel(output_channel), 1);
compare_sample = cell(numel(output_channel), 1);
for i = 1:numel(output_channel)
    if isempty(slice)
        exported_frame{i} = output_channel(i):interval:img_num;
        compare_sample{i} = ND2ReadSingle(filename, output_channel(i));
    else
        exported_frame{i} = slice(1):interval: slice(2);
        compare_sample{i} = ND2ReadSingle(filename, slice(1));
    end
end

minframe = min(cellfun(@numel, exported_frame));
exported_frame = cellfun(@(x) x(1:minframe), exported_frame, 'UniformOutput', 0);
exported_frame = uint16(cell2mat(exported_frame));

%Sort the channel by intensity. (largest the first)
intensity = cellfun(@(x) sum(x(:)), compare_sample);
[~, i_sort] = sort(intensity, 'descend');
exported_frame = exported_frame(i_sort, :);

%Auto contrast parameters.
lowhigh = autocontrastmovie(filename, exported_frame);

%Info of compressed images.
post_info.resize_scale = scale;  % scale of image resize.
post_info.scale = 6.5/obj/scale;  % um/px
post_info.original_fps = fps_original;  % original fps in the movie
post_info.original_period = period_original;  % s
post_info.final_fps = output_fps;   % final fps in the movie
post_info.final_period = period_final; % s
post_info.output_channel = output_channel;  % export channel
post_info.compressed_img_size = size(temp);  % export movie size
post_info.frames = exported_frame;
post_info.auto_contrast_para = lowhigh;  % auto contrast parameter for imadjust

end
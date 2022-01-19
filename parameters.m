% Parameters for ND2 to video with scalebar and time stamp.

%% File:
% filename, savedir
filename = 'G:\project\20210913_yw320_yw510_pdmswell_37C\4x_377_pdmswell_edge.nd2';
% savedir = 'E:\exp_script\GitProject\sample\';
[filedir, file, ~] = fileparts(filename);
savedir = strrep(filedir, 'project', 'project_processed');
if ~exist(savedir, 'dir')
    mkdir(savedir)
end

%% Image acquisition:
% objective, nFreqChannel, nPosFrames.

objective = 4;
nFreqDiv = 1;

%% Exported images:
% slice, exportedFreqChannelNo, shortestSideLength, isImgCombined,
% hasScalebar, hasScaleText, hasTimeStamp.

exportPara.slice = [];
exportPara.exportEveryNumFrame = 2;

% At most two dimensions can be selected. For example, if channelNo and
% XYNo contains multiple elements, ZNo must be a scalar.
exportPara.exportedFreqNo = []; 
exportPara.exportedChannelNo = []; 
exportPara.exportedXYNo = [];
exportPara.exportedZNo = [];
exportPara.shortestSideLength = 720;

processPara.contrastMethod = 2; % 0: no contrast; 1: auto contrast; 2: manual contrast
processPara.isImgCombined = 1;
processPara.hasScalebar = 1;
processPara.hasScaleText =1;
processPara.hasTimeStamp = 1;

%% Video:
% isCompressed, frameRate.

isCompressed = 1; % 1 for 'MPEG-4' and 0 for 'Grayscale AVI'
frameRate = 20;

%% EXE
demolabelimg;
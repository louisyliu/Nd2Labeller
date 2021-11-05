% Parameters for ND2 to video with scalebar and time stamp.

%% File:
% filename, savedir
filename = 'G:\project\20211010_YW510_pdmswell_differentvolume_height\YW510_4x_near_inlet_gd5.nd2';
% savedir = 'E:\exp_script\GitProject\sample\';
[filedir, file, ~] = fileparts(filename);
savedir = strrep(filedir, 'project', 'project_processed');
if ~exist(savedir, 'dir')
    mkdir(savedir)
end

%% Image acquisition:
% objective, nFreqChannel, nPosFrames.

objective = 4;
nFreqDiv = 2;

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

processPara.isAutoContrast = 1;
processPara.isManualContrast = 0;
processPara.isImgCombined = 1;
processPara.hasScalebar = 1;
processPara.hasScaleText = 1;
processPara.hasTimeStamp = 1;

%% Video:
% isCompressed, frameRate.

isCompressed = 1; % 1 for 'MPEG-4' and 0 for 'Grayscale AVI'
frameRate = 40;

%% EXE
% demo;
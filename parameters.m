% Parameters for ND2 to video with scalebar and time stamp.

%% File:
% filename, savedir
filename = 'G:\project\20211104_YW531_06PYVS_singlecell_response_light\531_06PYVS_20x_red2fish_filamentresponse_light.nd2';
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

processPara.isAutoContrast = 0;
processPara.isManualContrast = 1;
processPara.isImgCombined = 1;
processPara.hasScalebar = 1;
processPara.hasScaleText =1;
processPara.hasTimeStamp = 1;

%% Video:
% isCompressed, frameRate.

isCompressed = 1; % 1 for 'MPEG-4' and 0 for 'Grayscale AVI'
frameRate = 20;

%% EXE
demo;
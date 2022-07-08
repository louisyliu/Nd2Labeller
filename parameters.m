% Parameters for ND2 to video with scalebar and time stamp.

%% File:
% filename, savedir
filename = 'E:\project\20220703_plume_510\4x_510od15_closedPDMSwell_500umthick_biggestsize_g_d_unknown_DNA_unknown_localocillation.nd2';
% savedir = 'E:\paper_active_bulging\SIMovie\';
% savedir = 'G:\exp_script\GitProject\sample\';
[filedir, file, ~] = fileparts(filename);
savedir = strrep(filedir, 'project', 'project_processed');
savedir = [savedir '\'];
if ~exist(savedir, 'dir')
    mkdir(savedir)
end

%% Image acquisition:
% objective, nFreqDiv, startTime.

objective = 4;
nFreqDiv = 1;
startTime = 0; % s

%% Exported images:
% exportedT, exportedFreqChannelNo, shortestSideLength, needImgCombined,
% needScalebar, needScaleText, needTimeStamp. 
% Empty for all.

exportPara.exportedT = [1 2000]; % T from T(1) to T(2)
exportPara.exportEveryNumFrame = 2;

% At most two dimensions can be selected. For example, if channelNo and
% XYNo contains multiple elements, ZNo must be a scalar.
exportPara.exportedFreqNo = []; 
exportPara.exportedChannelNo = []; 
exportPara.exportedXYNo = [];
exportPara.exportedZNo = [];
exportPara.shortestSideLength = 720;

%% 
processPara.contrastMethod = 2; % 0: do nothing; 1: auto contrast; 2: manual contrast
processPara.drawROI = 0; % 0: do nothing; 1: draw ROI.
processPara.needScalebar = 1;
processPara.needScaleText =1;
processPara.needTimeStamp = 1;
processPara.title = {}; % title: cell array of character vectors 


%% Video:
% isCompressed, frameRate.

isCompressed = 1; % 1 for 'MPEG-4' and 0 for 'Grayscale AVI'
frameRate = 20;

%% Snapshot montage:
% needSnapshot, nSnap
% needSnapshot = 0;
% nSnap = 4;

%% Execute
labelimage;
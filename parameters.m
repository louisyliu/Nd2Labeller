% Parameters for ND2 to video with scalebar and time stamp.

%% File:
% filename, savedir
filename = 'G:\exp_script\GitProject\sample\splitfreq.nd2';
savedir = 'G:\exp_script\GitProject\sample\';


%% Image acquisition:
% objective, nFreqDiv, startTime.

objective = 4;
nFreqDiv = 2;
startTime = 0; % s

%% Exported images:
% exportedT, exportedFreqChannelNo, shortestSideLength, needImgCombined,
% needScalebar, needScaleText, needTimeStamp. 
% Empty for all.

exportPara.exportedT = [1 100]; % T from T(1) to T(2)
exportPara.exportEveryNumFrame = 2;

% At most two dimensions can be selected. For example, if channelNo and
% XYNo contains multiple elements, ZNo must be a scalar.
exportPara.exportedFreqNo = []; 
exportPara.exportedChannelNo = []; 
exportPara.exportedXYNo = [];
exportPara.exportedZNo = [];
exportPara.shortestSideLength = 720;

processPara.contrastMethod = 2; % 0: do nothing; 1: auto contrast; 2: manual contrast
processPara.needScalebar = 1;
processPara.needScaleText =1;
processPara.needTimeStamp = 1;

%% Video:
% isCompressed, frameRate.

isCompressed = 1; % 1 for 'MPEG-4' and 0 for 'Grayscale AVI'
frameRate = 20;

%% Snapshot montage:
% needSnapshot, nSnap
needSnapshot = 0;
nSnap = 4;

%% Execute
labelimage;
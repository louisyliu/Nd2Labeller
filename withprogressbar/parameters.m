% Parameters for ND2 to video with scalebar and time stamp.

%% File:
% filename = [filedir, file], savedir.

filedir = 'G:\project\20210815_lattice_inG5\';
file = '5inlargerpetridish_6min.nd2';
% or filename = 'G:\project\20210815_lattice_inG5\5inlargerpetridish_6min.nd2';
savedir = 'G:\project_processed\';

%% Image acquisition:
% objective, nFreqChannel.

objective = 4;
nFreqChannel = 1;

%% Exported images:
% exportedFreqChannelNo, shortestSideLength, isImgCombined, hasScalebar,
% hasScaleText, hasTimeStamp.

exportedFreqChannelNo = 1;
shortestSideLength = 720;
isImgCombined = 1;
hasScalebar = 1;
hasScaleText = 0;
hasTimeStamp = 1;

%% Video:
% isCompressed, frameRate.

isCompressed = 1; % 1 for 'MPEG-4' and 0 for 'Grayscale AVI'
frameRate = 40;

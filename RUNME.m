% Parameters for converting ND2 to video with scalebar and timestamp.

%% File
filename = 'B:\working.nd2';
filepath = fileparts(filename);
savedir = [filepath '\Video\'];
if ~exist(savedir, 'dir'), mkdir(savedir); end

%% Image Acquisition
objective = 4;
nFreqDiv = 2; 
startTime = 0; % seconds

%% Exported Image
exportPara.exportedT = []; % [startFrame endFrame], [] for all
exportPara.exportEveryNumFrame = 1; 
exportPara.exportedFreqNo = [];
exportPara.exportedChannelNo = [];
exportPara.exportedXYNo = [];
exportPara.exportedZNo = [];
exportPara.shortestSideLength = 720;

%% Image Processing Settings
processPara.contrastMethod = 1; % 0: none; 1: auto; 2: manual; 3: defined
processPara.contratPara = {[]}; % nx2 array
processPara.drawROI = 1; % 0: no; 1: yes.
processPara.needScalebar = 1;
processPara.needScaleText =1;
processPara.needTimeStamp = 1;
processPara.title = {'Phase contrast', 'FITC'}; 
processPara.timeLabel = {1, 'Light On'; 100, 'Light Off'}; % frame

%% Video
isCompressed = 1; % 1: 'MPEG-4'; 0: 'Grayscale AVI'
frameRate = 20;  % Recommend setting below 40 fps to optimize resource usage. 

%% Snapshot
needSnapshot = 0;
nSnap = 4;

%% Execute Conversion
% labelimage;
test_new_framework;
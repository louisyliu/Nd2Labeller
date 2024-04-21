% Parameters for converting ND2 to video with scalebar and timestamp.

%% File
filename = 'E:\20x_cells.nd2';

filepath = fileparts(filename);
savedir = [filepath '\Video\'];
if ~exist(savedir, 'dir'), mkdir(savedir); end

%% Image Acquisition
% objective, nFreqDiv, startTime.

objective = 4;
nFreqDiv = 1; 
startTime = 0; % seconds

%% Exported Image
% exportedT, exportedFreqChannelNo, shortestSideLength, needImgCombined,
% needScalebar, needScaleText, needTimeStamp.

% Leave empty [] to export all.

exportPara.exportedT = [1 2000]; % [startFrame endFrame], [] for all
exportPara.exportEveryNumFrame = 2; 

% Note: A maximum of two dimensions can be exported simultaneously.
% For example, if multiple channels (channelNo) and XY positions (XYNo) are
% selected, only a single Z-slice (ZNo) can be expoerted. 
exportPara.exportedFreqNo = [];
exportPara.exportedChannelNo = [];
exportPara.exportedXYNo = [];
exportPara.exportedZNo = [];
exportPara.shortestSideLength = 720;

%% Image Processing Settings
processPara.contrastMethod = 2; % 0: none; 1: auto; 2: manual
processPara.drawROI = 0; % 0: no; 1: yes.
processPara.needScalebar = 1;
processPara.needScaleText =1;
processPara.needTimeStamp = 1;
processPara.title = {'Phase contrast', 'FITC'}; % title: cell array of character vectors
processPara.timeLabel = {1, 'Light On'; 100, 'Light Off'};
% N x 2 cell array.  1st col: starting frame, 2nd col: label.  

%% Video
% isCompressed, frameRate.

isCompressed = 1; % 1: 'MPEG-4'; 0: 'Grayscale AVI'
frameRate = 20;  % Recommend setting below 40 fps to optimize resource usage. 

%% Snapshot
% needSnapshot, nSnap

needSnapshot = 0;
nSnap = 4;

%% Execute Conversion
labelimage;
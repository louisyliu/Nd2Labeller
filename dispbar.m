function dispbar(i,tot)
%% display progress bar of a for loop.    i = current loop.    tot = tot number of loops
barlength = floor(i/tot*50);
c = clock; % [year month day hour minute seconds]
txtTimeStamp = sprintf('%02d:%02d:%02d ',c(4),c(5),round(c(6)));
nof_extra = 80;

if i ~=tot
    TXT = sprintf('Processing [');
    BAR = sprintf([repmat('>',1,barlength) repmat('-',1,50-barlength)]);
    Percentage = sprintf('] %6.1f%%', i/tot*100);
    TxtPrint = [txtTimeStamp TXT BAR Percentage];
else
    TxtPrint = sprintf([txtTimeStamp 'Finish! 100%%         Time used: ' num2str(toc/(tot-1)*tot) ' s\n']);
end

% ************ Make safe for fprintf, replace control charachters
    TxtPrint = strrep(TxtPrint,'%','%%');
    TxtPrint = strrep(TxtPrint,'\','\\');

if i==1
    tic;
    idx_delete=0;
elseif i==tot
    idx_delete=nof_extra;
else
    idx_delete=nof_extra;
end

% *************** Print
fprintf([repmat('\b',1,idx_delete) TxtPrint]);

end
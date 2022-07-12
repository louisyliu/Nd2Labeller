function savesnapshot(snapshot, postInfo, titleOfImg, savename)
%SAVESNAPSHOT labels and saves the labelled snapshot.
%   savesnapshot(snapshot, postInfo, imgTitle, savename) labels the first
%   image with titles in [titleOfImg] and the last image with scalebar
%   according to [postInfo] and saves the labelled snapshots in the
%   [savename].

snapshot{end} = labelscale(snapshot{end}, postInfo);
snapshot{1} = labeltitle(snapshot{1}, postInfo, titleOfImg);
figure
montage(snapshot, 'ThumbnailSize', []);
axis off;
saveas(gcf, [savename, '.png']);
disptitle('Successfully save the snapshot in ');
disptitle([savename, '.png']);
end
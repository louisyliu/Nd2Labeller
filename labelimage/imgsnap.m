function snapshot = imgsnap(img, nSnap)
%IMGSNAP takes snapshots of an image sequence.
%   snapshot = imgsnap(img, nSnap) extracts the equal-interval of
%   snapshots.  The number of snapshots is [nSnap].  The snapshots stores
%   in a cell array of [snapshot].

iSnapshot = round(linspace(1, size(img, 3), nSnap));
icurrent = 0;
snapshot = cell(nSnap, 1);
for i = iSnapshot
    icurrent = icurrent + 1;
    snapshot{icurrent} = img(:,:,i);
end
end
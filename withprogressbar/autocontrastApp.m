J = imread('pout.tif');
imshow(J)  %Shows(I) as an image
imcontrast(imshow(J));
win_min = str2double(get(findobj(imcontrast(imshow(J)), 'tag', 'window min edit'), 'String'));
win_max = str2double(get(findobj(imcontrast(imshow(J)), 'tag', 'window max edit'), 'String')); 
imh = imshow(im2double(J));
[closewin_min, closewin_max]= mainfun1(imh);
disp(win_min)
disp(win_max)
disp(closewin_min)
disp(closewin_max)
uiwait
G = imadjust(J,[closewin_min/win_max closewin_max/win_max],[0 1]);
imshowpair(J,G,'Montage')
function [out1, out2] = mainfun1(imh)
out1 = []; % important to allocate here!
out2 = [];
ich = imcontrast(imh);
set(ich, 'CloseRequestFcn',@myClose)
%
    function myClose(h,~)
        out1 = str2double(get(findobj(h,'tag','window min edit'), 'String'));
        out2 = str2double(get(findobj(h,'tag','window max edit'), 'String'));
        delete(h)
    end
%
waitfor(ich)
end

try 
    b(a);
catch ME
    pause;
end
    
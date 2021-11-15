function [lowv, highv] = manualcontrast(img)

lowv = []; % important to allocate here!
highv = [];
fig = figure;

imh = imshow(img);
ich = imcontrast(imh);
set(ich, 'CloseRequestFcn', @myClose)
    function myClose(h,~)
        lowv = str2double(get(findobj(h,'tag','window min edit'), 'String'));
        highv = str2double(get(findobj(h,'tag','window max edit'), 'String'));
        delete(h)
    end
waitfor(ich);
close(fig);
end
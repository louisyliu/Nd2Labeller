function [img_time, post_info_f] = stamptime(img, post_info)

[img_height, img_width, img_num] = size(img);
fps = post_info.final_fps;
post_info_f = post_info;
img_time = img;

position = [round(0.007*img_width) round(0.007*img_height)];
period = (img_num-1)/fps;
interval = 1/fps; % s

%Calculate the time interval (s)
if interval < 1
    decimal_num = -floor(log10(interval));
    interval = round(interval, 3);  % s
else
    decimal_num = 0;
    interval = round(interval,1);  % s
end
single_num = floor(log10(period))+1;


for i_img = 1:img_num
    
    time_stamp = (i_img-1) * interval;
    
    %Evaluate time format
    if period < 300
        % if period is shorter than 5 min.  format x.xx s.
        text_str = sprintf(['%' num2str(decimal_num + single_num + 1) '.' num2str(decimal_num) 'f s'],time_stamp);
    elseif period < 3600
        % if period is shorter than 1 h.  format xx:xx (m:s).
        sec = floor(mod(time_stamp,60));
        min = floor(time_stamp/60);
        text_str = sprintf('%02d:%02d (m:s)',min, sec);
    else
        % if period is longer than 1 h.  format xx:xx:xx (h:m:s) or xx:xx (h:m).
        hour = floor(time_stamp/3600);
        remainer = mod(time_stamp,3600);
        min = floor(remainer/60);
        sec = floor(mod(remainer,60));
        if mod(round(interval), 3600) == 0
            text_str = sprintf('%02d h',hour);
        elseif mod(round(interval), 60) == 0
            text_str = sprintf('%02d:%02d (h:m)',hour, min);
        else
            text_str = sprintf('%02d:%02d:%02d (h:m:s)',hour, min, sec);
        end
    end
    
    RGB = insertText(img_time(:,:,i_img),position,text_str,'Font','Lucida Console' ,'FontSize',26,'BoxOpacity', 0, 'TextColor','white');
    
    %Examine the image is OK.
    if i_img == 1
        imshow(RGB(:,:,1));
        goornot = input('Is it OK? y/n','s');
        while strcmpi(goornot, 'n') && strcmpi(goornot, 'y')
            goornot = input('Is it OK? y/n','s');
        end
        if strcmpi(goornot, 'n')
            disp('QAQ: Unsatisfied with labeling.');
            return;
        end
        close(gcf);
    end
    
    img_time(:,:,i_img) = RGB(:,:,1);
    dispbar(i_img, img_num);
end

end
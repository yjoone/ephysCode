function frame = timeToFrame(timeStr,frameRate)

% This function converts time info form TDT recorded video to frame numbers
% time format should be hh:mm:ss

if nargin < 2
    frameRate = 30;
end

hr_s = timeStr(1:2);
min_s = timeStr(4:5);
sec_s = timeStr(7:8);

hr = str2num(hr_s);
min = str2num(min_s);
sec = str2num(sec_s);

frame = (((hr*60)+min)*60+sec)*30;


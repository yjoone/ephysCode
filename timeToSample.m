function sampleLoc = timeToSample(timeStr,Fs,frameRate)

% This function converts time info form TDT recorded video to sample number
% time format should be hh:mm:ss

if nargin < 2
    frameRate = 30;
    Fs = 24414.0625;
elseif nargin < 3
    frameRate = 30;
end

frame = timeToFrame(timeStr);

sampleLoc = round(frame*Fs/frameRate);

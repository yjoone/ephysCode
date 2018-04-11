function filtData = spikeSigFilt(rawData)

% Edit 050617 YJK.
% 1. Changed the filter function from filter to filt filt
% 2. Changed the filter order from 1 to 3

Fs = 24414.0625;
filtOrder = 3;
cutoffFreq = 300;

% % filter the data
% [b,a] = butter(filtOrder,cutoffFreq/(Fs/2),'high');
% filtData = filter(b,a,rawData);

% filter the data
[b,a] = butter(filtOrder,cutoffFreq/(Fs/2),'high');
filtData = filtfilt(b,a,double(rawData));
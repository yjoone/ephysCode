function [np,idx] = runNoiseDetection(data,Fs)

if nargin < 2
    Fs = 24414.0625;
end

% computer array limit and 2^x window
window = 33554432;

len = length(data);

for i = 1:floor(len/window)
    idx(i,1) = ((i-1)*window)+1;
    idx(i,2) = i*window;
    [data_new,data_newYOffset,artifactIDs,outputParams] = artifact_removal_Islam2015_updatedLA(data(idx(i,1):idx(i,2))', Fs);
    d = data_new - data(idx(i,1):idx(i,2))';
    np(i) = sum(abs(d) > 2e-4) / (idx(i,2)-idx(i,1)+1);
    keyboard
end

idx(i+1,1) = (idx(i,end)+1);
idx(i+1,2) = len;
[data_new,data_newYOffset,artifactIDs,outputParams] = artifact_removal_Islam2015_updatedLA(data(idx(i,1):idx(i,2))', Fs);
d = data_new - data(idx(i,1):idx(i,2));
np(i+1) = sum(abs(d) > 2e-3) / (idx(i+1,2)-idx(i+1,1)+1);

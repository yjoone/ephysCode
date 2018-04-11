function [spikeLoc,spikes,sigProp] = spikeDetect(rawData)

% hard code parameters. To be user inputted later
Fs = 24414.0625;
filtOrder = 1;
cutoffFreq = 500;
spikeThresh = -0.5e-4;
noiseStdThresh = 1.6e-5;
binSize = 1000;


% get signal length
sigLen = length(rawData);

% filter the data
filtData = spikeSigFilt(rawData);

% % filter the data
% [b,a] = butter(filtOrder,cutoffFreq/(Fs/2),'high');
% filtData = filter(b,a,rawData);

spike_idx_all = [];
sigPropCounter = 1;

% for each bins calculate mean and std to detect noisy region & 
for i = 1:binSize:sigLen-binSize
    index = i:(i+binSize-1);
    sigChunk = filtData(index,1);
    sigChunkStd = std(sigChunk);
    if sigChunkStd < noiseStdThresh
        chunkSpike_ind = find(sigChunk<spikeThresh);
        spike_idx = chunkSpike_ind+i;
        spike_idx_all = [spike_idx_all; spike_idx];
    end
    sigProp(sigPropCounter,1) = mean(sigChunk);
    sigProp(sigPropCounter,2) = std(sigChunk);
    sigPropCounter = sigPropCounter+1;
end

% based on threshold location, extract spikes
spike_idx_diff = diff(spike_idx_all);
spike_jump = find(spike_idx_diff > 1);

spikeLoc = [spike_idx_all(1,1); spike_idx_all(spike_jump+1)];
spikes = [];
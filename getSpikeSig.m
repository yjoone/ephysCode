function spikes = getSpikeSig(rawData,spikeLoc)


binSize = 100; % data points
spikeNum = length(spikeLoc);

% filter the data same way
filtData = spikeSigFilt(rawData);

for i = 1:spikeNum
    spikeLoc_i = spikeLoc(i,1);
    spikes(i,:) = filtData(spikeLoc_i - binSize:spikeLoc_i+binSize);
end

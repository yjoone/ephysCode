function phaseData = calcSignalPhase(rawSignal,spikeLoc,samplingRate,freq,freqBand)

% calcSignalPhase takes in a signal, and calculates phase of the raw signal

% Hard code
binSize_s = 1;

sigLen = length(rawSignal);
spikeLocCount = length(spikeLoc);
binSize_sample = binSize_s*samplingRate;
freqh = freq+freqBand/2;
freql = freq-freqBand/2;

% get rid of first few spikes less than binsize
spikeLoc = spikeLoc(spikeLoc >= binSize_sample);

for i = 1:spikeLocCount
    try
        dataChunk = rawSignal(spikeLoc(i,1)-binSize_sample:spikeLoc(i,1)+binSize_sample);
        phaseData(i,:) = eegfilt(dataChunk',samplingRate,freql,freqh);
    end
end

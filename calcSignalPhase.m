function [gammaData,ampData,phaseData,spikeLocUsed] = calcSignalPhase(rawSignal,spikeLoc,samplingRate,freq,freqBand)

% calcSignalPhase takes in a signal, and calculates phase of the raw signal

% Hard code
binSize_s = 1;
numProcessor = 4;

sigLen = length(rawSignal);
spikeLocCount = length(spikeLoc);
binSize_sample = binSize_s*samplingRate;
freqh = freq+freqBand/2;
freql = freq-freqBand/2;

% get rid of first few spikes less than binsize
spikeLocUsed = spikeLoc(spikeLoc > binSize_sample & spikeLoc < sigLen-binSize_sample);

% parse the data for parallel computing
spikeNum = length(spikeLocUsed);
coreLen = floor(spikeNum/numProcessor);

for k = 1:numProcessor
    temp_idx = ((k-1)*coreLen+1):(k*coreLen);
    parSpikeLoc{k,1} = spikeLocUsed(temp_idx,1);
end

% add in the remainders
if rem(spikeNum,numProcessor) ~= 0
    end_i = rem(spikeNum,numProcessor);
    for l = 1:end_i
        end_ii = end_i-l;
        tempBox = parSpikeLoc{l,1};
        tempBox = [tempBox; spikeLocUsed(end-end_ii,1)];
        parSpikeLoc{l,1} = tempBox;
    end
end


parfor i = 1:numProcessor
    SL = parSpikeLoc{i,1};
    for j = 1:length(SL)
        dataChunk = rawSignal(SL(j,1)-binSize_sample:SL(j,1)+binSize_sample);
        gamma = eegfilt(dataChunk',samplingRate,freql,freqh);
        pargammaData{i,1}(j,:) = gamma;
        parampData{i,1}(j,:) = abs(hilbert(gamma));
        parphaseData{i,1}(j,:) = angle(hilbert(gamma));
    end
end

gammaData=[];
ampData=[];
phaseData=[];
for j = 1:numProcessor
    gammaData = [gammaData; pargammaData{j,1}];
    ampData = [ampData; parampData{j,1}];
    phaseData = [phaseData; parphaseData{j,1}];
end

% for i = 1:spikeLocCount
%     try
%         dataChunk = rawSignal(spikeLocUsed(i,1)-binSize_sample:spikeLocUsed(i,1)+binSize_sample);
%         phaseData(i,:) = eegfilt(dataChunk',samplingRate,freql,freqh);
%     end
% end

samplingRate = 24414.0625;
freq = 50;
freqBand = 4;
xbins = [-2.5*pi:pi/6:4.5*pi]+pi/12;


cNums = find(clusterStruct.clusterstat(:,2) > 100);
gammaDataAll = [];
ampDataAll = [];
phaseDataAll = [];

for i = 1:length(cNums)
    ci = clusterStruct.clusterstat(i,1);
    si = find(clusterStruct.clusters{1} == ci);
    spikeLoc = clusterStruct.spikes{1}(si,1);
     [gammaData,ampData,phaseData,spikeLocUsed] = ...
          calcSignalPhase(data,spikeLoc,samplingRate,freq,freqBand);
     
%      phaseDataAll = [phaseData(:,24415);phaseData(:,24415)+2*pi];
%      figure; hist(phaseDataAll,xbins);
    figure; hold on;
    for j = 1:length(spikeLoc)
        plot(spikes{1}(si(j),2:end));
    end
    
%     gammaDataAll = [gammaDataAll; gammaData(:,24415)];
%     ampDataAll = [ampDataAll; ampData(:,24415)];
%     phaseDataAll = [phaseDataAll; phaseData(:,24415)];
    
    eval(['phaseStruct.c' num2str(i) '.gammaData = gammaData(:,24415);'])
    eval(['phaseStruct.c' num2str(i) '.ampData = ampData(:,24415);'])
    eval(['phaseStruct.c' num2str(i) '.phaseData = phaseData(:,24415);'])
     
     % keyboard
end

    
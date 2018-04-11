function [coherenceStruct,S1Struct,S2Struct,rasterWindowTimesSamplesStruct,fSpect] = runCoherence_ds(PFC,NAcc,BLA)

PFC_ds = TDT_downSample(PFC);
NAcc_ds = TDT_downSample(NAcc);
BLA_ds = TDT_downSample(BLA);

dam.signal.PFC = PFC_ds';
dam.signal.NAcc = NAcc_ds';
dam.signal.BLA = BLA_ds';
dam.samplerate = 24414.0625 / 48; % divide by 48 due to down sampling

startLastRangeSamples = [1 numel(BLA_ds)];
chanNameCell1 = {'PFC','PFC','BLA'};
chanNameCell2 = {'NAcc','BLA','NAcc'};
dataAcq = 'TDT';


[coherenceStruct,S1Struct,S2Struct,rasterWindowTimesSamplesStruct,fSpect] = ...
    MakeCoherenceRaster(dam,startLastRangeSamples,chanNameCell1,chanNameCell2,dataAcq,'specifyBehavs',false,'keepFrequenciesRange',[3 100]);

function [modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = runCFC_ds(PFC,NAcc,BLA)

PFC_ds = TDT_downSample(PFC);
NAcc_ds = TDT_downSample(NAcc);
BLA_ds = TDT_downSample(BLA);

dam.signal.PFC = PFC_ds';
dam.signal.NAcc = NAcc_ds';
dam.signal.BLA = BLA_ds';
dam.samplerate = 24414.0625 / 48; % divide by 48 due to down sampling

startLastRangeSamples = [1 numel(BLA_ds)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'TDT';

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq);
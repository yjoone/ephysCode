% load the dam file from SamplePipeline.m

load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Miranda\damStructures.mat')

dam.signal.NAcc = damNeil_NAcc_DS.trials.signal;
dam.signal.PFC = damNeil_PFC_DS.trials.signal;
dam.signal.BLA = damNeil_BLA_DS.trials.signal;

dam.samplerate = samplerate;
startLastRangeSamples = [1 numel(dam.signal.NAcc)];
chanNameCell1 = {'NAcc','NAcc','PFC'};
chanNameCell2 = {'PFC','BLA','BLA'};
dataAcq = 'NL';

[coherenceStruct,S1Struct,S2Struct,rasterWindowTimesSamplesStruct,fSpectOut] = MakeCoherenceRaster(dam,startLastRangeSamples,chanNameCell1,chanNameCell2,dataAcq,'specifyBehavs',false,'keepFrequenciesRange',[3 95]);
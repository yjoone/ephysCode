% scirpt to run a sample pipeline for CFC analysis

% load the ephys data
load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Habituation2_And_Cohab_rawData.mat');

% set up the input structure and variables 
dam.signal.PFC = chan3;
dam.signal.NAcc = chan4;
dam.signal.BLA = chan5;
dam.samplerate = 199.805; % Neurologger sampling rate

startLastRangeSamples = [1 numel(chan3)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

% add in the behavior with sample indices

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq);

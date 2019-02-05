% scirpt to run a sample pipeline for CFC analysis

% load the ephys data
load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Habituation2_And_Cohab_rawData.mat');

% set up the input structure and variables 
dam.signal.PFC = damNeil_PFC.trials.signal;
dam.signal.NAcc = damNeil_NAcc.trials.signal;
dam.signal.BLA = damNeil_BLA.trials.signal;
dam.samplerate = 199.805; % Neurologger sampling rate

dam.neuralidsbehavs = damNeil_BLA.trials.behavindices;

startLastRangeSamples = [1023259 5349557];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

% add in the behavior with sample indices

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq);

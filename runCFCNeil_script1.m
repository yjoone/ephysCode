% script to take in completedRun.mat file from each of the animal, and
% run the CFC analysis

clear all
clc

% Specifically for Neil
animalID = 'Paul'
filepath = ['C:\Users\ykwon36\Documents\workspace_Jim\' animalID ];
outfilepath = [filepath '\Analysis_CFC'];
samplerate = 1.998048780487805e+02;
cd(filepath)

% load in completedRun.mat
load(['C:\Users\ykwon36\Documents\workspace_Jim\' animalID '\completedRun.mat'])

% format the data to be inputted to CFC analysis
dam.neuralidsbehavs = damNeil_NAcc.trials.behavindices; 
dam.signal.PFC = damNeil_PFC.trials.signal  
dam.signal.NAcc = damNeil_NAcc.trials.signal  
dam.signal.BLA = damNeil_BLA.trials.signal  
dam.samplerate = samplerate;

startLastRangeSamples = [1 numel(dam.signal.PFC)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';


[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = runModBehavior(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq);

save('completedCFCRun.mat')

modStruct = plotModStruct(modStruct,fhigh,flow,animalID,outfilepath)
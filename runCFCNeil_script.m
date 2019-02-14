% scirpt to run a sample pipeline for CFC analysis

% load the ephys data
fullfile = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Neil\Habituation2_and_Cohab_Neil_113018.hex';
% load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Habituation2_And_Cohab_rawData.mat');

if isunix
    fullfile = win2unix(fullfile);
end
[datacell,samplerate] = readNL_gka(fullfile);

% load in the behavior details
if isunix
    load(win2unix('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Neil\completedRun.mat'),'damNeil_NAcc')
else
    load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Neil\completedRun.mat','damNeil_NAcc')
end

dam.neuralidsbehavs = damNeil_NAcc.trials.behavindices; 
    % this assumes the loaded file behaviorindices are for mountingMale.


% set up the input structure and variables 
dam.signal.PFC = datacell{1}(3,:);
dam.signal.NAcc = datacell{1}(4,:);
dam.signal.BLA = datacell{1}(5,:);
dam.samplerate = samplerate; % Neurologger sampling rate

startLastRangeSamples = [1 numel(dam.signal.PFC)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

% add in the behavior with sample indices

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = runModBehavior(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq);

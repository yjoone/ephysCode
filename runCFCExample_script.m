% scirpt to run a sample pipeline for CFC analysis

outfolder = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All';

% run Franz
load R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Habituation2_And_Cohab_rawData

dam.signal.PFC = chan3;
dam.signal.NAcc = chan4;
dam.signal.BLA = chan5;
dam.samplerate = 199.805; % Neurologger sampling rate

startLastRangeSamples = [1 numel(chan3)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq,'specifyBehavs',false);

save(fullfile(outfolder,'Franz_Cohab_CFC_noBehav'))

clear all

% run Miranda
load R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Miranda\Habituation2_and_Cohab_Miranda_112218
outfolder = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All';

dam.signal.PFC = chan3;
dam.signal.NAcc = chan5;
dam.signal.BLA = chan6;
dam.samplerate = 199.805; % Neurologger sampling rate

startLastRangeSamples = [1 numel(chan3)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq,'specifyBehavs',false);

save(fullfile(outfolder,'Miranda_Cohab_CFC_noBehav'))
clear all

% run Neil
load R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Neil\Habituation2_and_Cohab_Neil_113018
outfolder = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All';

dam.signal.PFC = chan3;
dam.signal.NAcc = chan4;
dam.signal.BLA = chan5;
dam.samplerate = 199.805; % Neurologger sampling rate

startLastRangeSamples = [1 numel(chan3)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq,'specifyBehavs',false);

save(fullfile(outfolder,'Neil_Cohab_CFC_noBehav'))
clear all

% run O
load R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\O\Habituation2_and_Cohab_O_113018
outfolder = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All';

dam.signal.PFC = chan3;
dam.signal.NAcc = chan4;
dam.signal.BLA = chan5;
dam.samplerate = 199.805; % Neurologger sampling rate

startLastRangeSamples = [1 numel(chan3)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq,'specifyBehavs',false);

save(fullfile(outfolder,'O_Cohab_CFC_noBehav'))
clear all

% run P
load R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Paul\Habituation2_And_Cohab_Paul_012519
outfolder = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All';

dam.signal.PFC = chan3;
dam.signal.NAcc = chan5;
dam.signal.BLA = chan6;
dam.samplerate = 199.805; % Neurologger sampling rate

startLastRangeSamples = [1 numel(chan3)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq,'specifyBehavs',false);

save(fullfile(outfolder,'Paul_Cohab_CFC_noBehav'))
clear all

% run Q
load R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Q\Habituation2AndCohab_Q_030819
outfolder = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All';

dam.signal.PFC = chan3;
dam.signal.NAcc = chan4;
dam.signal.BLA = chan5;
dam.samplerate = 199.805; % Neurologger sampling rate

startLastRangeSamples = [1 numel(chan3)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq,'specifyBehavs',false);

save(fullfile(outfolder,'Q_Cohab_CFC_noBehav'))
clear all

% run R
load R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\R\Habituation2_and_cohab_R_031419
outfolder = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All';

dam.signal.PFC = chan3;
dam.signal.NAcc = chan4;
dam.signal.BLA = chan5;
dam.samplerate = 199.805; % Neurologger sampling rate

startLastRangeSamples = [1 numel(chan3)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq,'specifyBehavs',false);

save(fullfile(outfolder,'R_Cohab_CFC_noBehav'))
clear all

% run T
load R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\T\Habituation2AndCohab_T_032619
outfolder = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All';

dam.signal.PFC = chan3;
dam.signal.NAcc = chan4;
dam.signal.BLA = chan5;
dam.samplerate = 199.805; % Neurologger sampling rate

startLastRangeSamples = [1 numel(chan3)];
chanNameCellPhaseFreq = {'PFC','PFC','NAcc','NAcc','BLA','BLA'};
chanNameCellAmpFreq = {'NAcc','BLA','PFC','BLA','PFC','NAcc'};
dataAcq = 'NL';

[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,...
    chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq,'specifyBehavs',false);

save(fullfile(outfolder,'T_Cohab_CFC_noBehav'))
clear all
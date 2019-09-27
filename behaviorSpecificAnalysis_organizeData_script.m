% sample script based on PV20130829B_analysis_Joe_example.m from Liz Ann

%% default parameters
durSecondsAnalysisWindow = 1; %seconds
% syncdetailfilename = 'SyncDetail'; % excel file with start/stop time of neurologger and video sync pulses
    % used in inCreateTimestampLogNL
syncSystem = 'Arduino'; %default. Used inCreateTimestampLogNL
% behavNames = {'mountingMale','huddlingFemale','huddlingMale','partnergroomingFemale','partnergroomingMale','sniffingFemale','sniffingMale','selfgroomingFemale','bitingFemale','approachFemale','approachMale','rearingFemale'};
behavNames = {'approachMale'}; % check if this can be obtained from the 
    % excel file or from the scoring iteration file

%% step 1: set appropriate paths
initializePath

currDir = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\T';
curPath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\LizAnnPipeLineExample\';
databasepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\MasterDBVole.xls';

if isunix
    %cd(win2unix(currDir));
    % path(path,win2unix(curPath));
    mdb = xlsreadMasterDBVole(win2unix(databasepath));
else
    cd(currDir);
    path(path,curPath);
    mdb = xlsreadMasterDBVole(databasepath);
end

% sync detail filename
syncdetailfilename = 'SyncDetail.xlsx';
timestamplogfilename = 'timestamplog.xlsx';
Chronux_startup

%% step 2: get neural and behavioral data
recd_DC = getrecd_mdb('LFP',mdb,{'Animal','Scorer'},{{'T'},{'DC'}},'NeuralBehav','both');
% recdNeil_Nacc_DS = recd_DC(1);
% recdNeil_PFC_DS = recd_DC(2);
recdNeil_PFC_DS = recd_DC(1);
samplerate = recdNeil_Nacc_DS.Samplerate;

%% step 4: get raw data

damNeil_PFC_DS = loadrecd_mdb_drafting20130214(recdNeil_PFC_DS,mdb);

% script to plot behavior specific analysis

data = damNeil_PFC_DS.trials.signal;
behbox = damNeil_PFC_DS.trials.behavindices.approachMale;

[r,c] = size(behbox);

for i = 1:r
    figure; plot(data(behbox(i,1):behbox(i,2)))
end
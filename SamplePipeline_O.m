% sample script based on PV20130829B_analysis_Joe_example.m from Liz Ann

%% hard code
durSecondsAnalysisWindow = 2; %seconds

%% step 1: set appropriate paths
initializePath

currDir = 'C:\Users\ykwon36\Documents\workspace_Jim\O';
curPath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\LizAnnPipeLineExample\';
databasepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\MasterDBVole_samplePipeline.xls';

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

Chronux_startup

%% step 2: get neural and behavioral data
recd_DC = getrecd_mdb('LFP',mdb,{'Animal','Scorer'},{{'O'},{'JK'}},'NeuralBehav','both');
% recdNeil_Nacc_DS = recd_DC(1);
% recdNeil_PFC_DS = recd_DC(2);
recdNeil_PFC_DS = recd_DC(1);
recdNeil_Nacc_DS = recd_DC(2);
recdNeil_BLA_DS = recd_DC(3);
samplerate = recdNeil_Nacc_DS.Samplerate;

%% step 3: put behavior names? - check if it's necessary or can be obtained from xls file.
% behavNames = {'mountingMale','huddlingFemale','huddlingMale','partnergroomingFemale','partnergroomingMale','sniffingFemale','sniffingMale','selfgroomingFemale','bitingFemale','approachFemale','approachMale','rearingFemale'};
behavNames = {'mountingMale'};
%% step 4: get raw data

damNeil_NAcc_DS = loadrecd_mdb_drafting20130214(recdNeil_Nacc_DS,mdb);
damNeil_PFC_DS = loadrecd_mdb_drafting20130214(recdNeil_PFC_DS,mdb);
damNeil_BLA_DS = loadrecd_mdb_drafting20130214(recdNeil_BLA_DS,mdb);


threshStartOffsetSecondsStruct = struct('mountingMale',1,'huddlingFemale',5,...
    'huddlingMale',5,'partnergroomingFemale',1,'partnergroomingMale',1,...
    'sniffingFemale',1,'sniffingMale',1,'selfgroomingFemale',1,'bitingFemale',1,...
    'approachFemale',1,'approachMale',1,'rearingFemale',1);
threshOverlapSecondsStruct = struct('mountingMale',durSecondsAnalysisWindow,...
    'huddlingFemale',durSecondsAnalysisWindow,'huddlingMale',durSecondsAnalysisWindow,...
    'partnergroomingFemale',durSecondsAnalysisWindow,'partnergroomingMale',durSecondsAnalysisWindow,...
    'sniffingFemale',durSecondsAnalysisWindow,'sniffingMale',durSecondsAnalysisWindow,...
    'selfgroomingFemale',durSecondsAnalysisWindow,'bitingFemale',durSecondsAnalysisWindow,...
    'approachFemale',durSecondsAnalysisWindow,'approachMale',durSecondsAnalysisWindow,...
    'rearingFemale',durSecondsAnalysisWindow);
threshOverlapVals = [];
for z = 1:numel(behavNames)
    val = threshOverlapSecondsStruct.(behavNames{z});
    threshOverlapVals = [threshOverlapVals val];
end

behavIntersect_NAcc = IntersectDamsBehavTwoScorersNL(damNeil_NAcc_DS.trials.behavindices,...
    damNeil_NAcc_DS.trials.behavindices,threshStartOffsetSecondsStruct,threshOverlapSecondsStruct,samplerate);
behavIntersect_PFC = IntersectDamsBehavTwoScorersNL(damNeil_PFC_DS.trials.behavindices,...
    damNeil_PFC_DS.trials.behavindices,threshStartOffsetSecondsStruct,threshOverlapSecondsStruct,samplerate);
behavIntersect_BLA = IntersectDamsBehavTwoScorersNL(damNeil_BLA_DS.trials.behavindices,...
    damNeil_BLA_DS.trials.behavindices,threshStartOffsetSecondsStruct,threshOverlapSecondsStruct,samplerate);

damNeil_NAcc_intersect = damNeil_NAcc_DS;
damNeil_NAcc_intersect.trials.behavindices = behavIntersect_NAcc; % replace original behavior times with intersection behavior times
damNeil_PFC_intersect = damNeil_PFC_DS;
damNeil_PFC_intersect.trials.behavindices = behavIntersect_PFC;
damNeil_BLA_intersect = damNeil_BLA_DS;
damNeil_BLA_intersect.trials.behavindices = behavIntersect_BLA;

%% step 5: Define which dam will use for rest of analysis
damNeil_NAcc = damNeil_NAcc_intersect;
damNeil_PFC = damNeil_PFC_intersect;
damNeil_BLA = damNeil_BLA_intersect;

% %% Change the behaviorindices from mountingMale to random epochs of behavior
% % from Neil.
% 
% damNeil_BLA.trials.behavindices.mountingMale = [5.68e5 5.71e5; 1.705e6 1.707e6; 2.702e6 2.705e6; 3.405e6 3.407e6; 4.31e6 4.313e6; 5.172e6 5.175e6];
% damNeil_NAcc.trials.behavindices.mountingMale = [5.68e5 5.71e5; 1.705e6 1.707e6; 2.702e6 2.705e6; 3.405e6 3.407e6; 4.31e6 4.313e6; 5.172e6 5.175e6];


%% Check that behavioral names and indices for a given animal are actually equal across channels (what you assume above)
CheckAcrossChannels({damNeil_NAcc},{damNeil_PFC})
CheckAcrossChannels({damNeil_NAcc},{damNeil_BLA})
CheckAcrossChannels({damNeil_BLA},{damNeil_PFC})
% CheckAcrossChannels({recd20130829B_NAcc_AS,recd20130829B_NAcc_WM,recd20130829B_NAcc_AS},{recd20130829B_PFC_AS,recd20130829B_PFC_WM,recd20130829B_NAcc_WM},'compareType','samplerate')
%%%%%%%%%%%% double check the above commented line
%% specify epoch duration
epochDur = durSecondsAnalysisWindow; %seconds

if ~isempty(find(epochDur<threshOverlapVals,1)) && isequal(damNeil_NAcc.trials.behavindices,...
        damNeil_NAcc_intersect.trials.behavindices)
    error('desired epoch duration less than minimum size of data epochs')
end

TStruct = struct;
for i=1:numel(behavNames)
    TStruct.(behavNames{i})=epochDur;
end


%% Specify experiment range in samples. load in synchronization detail information from the excel file
try
    [num,txt] = xlsread(syncdetailfilename);
    for i = 2:length(txt) % start from second row to skip headers
        assign(txt{i,1},num(i-1,1)); % num variable does not have header so readjust
    end
catch
    disp('make sure there is the syncdetail.xlsx file in the experiment file path')
    keyboard
end

cohabRange = [NLstartcohab NLendcohab];
%
% % habitRange = [568946 1298927]; % ~60.9 min habituation
% cohabRange = [1313167 5653055];% ~362.0 min cohabitation
% % rehabitRange = [5729757 5953810];% ~18.7 min rehabituation
% % foodRewardRange = [5954935 6668314];% ~59.5 min food reward
% % range(1) is start of session & range(2) is last point of session
% % (inclusive)

sixHrCohabLastPoint = cohabRange(1)+round(6*3600*samplerate)-1;
ExptRangeSamples_Neil = [cohabRange(1) sixHrCohabLastPoint];
if cohabRange(2)<sixHrCohabLastPoint
    error('cohabitation duration less than 6 hours')
end




% OLD
% [568447 (568447+ceil(recd20130829B_NAcc.Samplerate*3600*1)-1)]; % 1hr habituation
% [1313073 (1313073+ceil(recd20130829B_NAcc.Samplerate*3600*6)-1)]; % 6hr cohab
% [5729278 (5729278+ceil(recd20130829B_NAcc.Samplerate*900)-1)]; % 15 min rehab
% [5954929 6668797-1]; % food rew. - use last arduino syn as end

%% Create chronux data structures
[chronuxDataStruct_Neil_NAcc,epochIndices_Neil_NAcc,sampleIndices_Neil_NAcc,T_Neil_NAcc] = ...
    ConvertIndicesToChronuxFormat(damNeil_NAcc.trials.behavindices,damNeil_NAcc.trials.signal,...
    TStruct,samplerate,'regionNeuralData','between','boundsSamples',ExptRangeSamples_Neil);
[chronuxDataStruct_Neil_PFC,epochIndices_Neil_PFC,sampleIndices_Neil_PFC,T_Neil_PFC] = ...
    ConvertIndicesToChronuxFormat(damNeil_PFC.trials.behavindices,damNeil_PFC.trials.signal,...
    TStruct,samplerate,'regionNeuralData','between','boundsSamples',ExptRangeSamples_Neil); %behavindices and samplerate should be same
[chronuxDataStruct_Neil_BLA,epochIndices_Neil_BLA,sampleIndices_Neil_BLA,T_Neil_BLA] = ...
    ConvertIndicesToChronuxFormat(damNeil_BLA.trials.behavindices,damNeil_BLA.trials.signal,...
    TStruct,samplerate,'regionNeuralData','between','boundsSamples',ExptRangeSamples_Neil); %behavindices and samplerate should be same

%% Match epochs across channels for given animal
[chronuxDataStruct_Neil_NAcc_Matched_withPFC, chronuxDataStruct_Neil_PFC_Matched_withNAcc,...
    sampleIndices_Neil_Matched_withNAccAndPFC] = ...
    MatchDataAcrossEpochsNL(chronuxDataStruct_Neil_NAcc,chronuxDataStruct_Neil_PFC,...
    epochIndices_Neil_NAcc,epochIndices_Neil_PFC,sampleIndices_Neil_NAcc);

[chronuxDataStruct_Neil_NAcc_Matched_withBLA, chronuxDataStruct_Neil_BLA_Matched_withNAcc,...
    sampleIndices_Neil_Matched_withNAccAndBLA] = ...
    MatchDataAcrossEpochsNL(chronuxDataStruct_Neil_NAcc,chronuxDataStruct_Neil_BLA,...
    epochIndices_Neil_NAcc,epochIndices_Neil_BLA,sampleIndices_Neil_NAcc);

[chronuxDataStruct_Neil_BLA_Matched_withPFC, chronuxDataStruct_Neil_PFC_Matched_withBLA,...
    sampleIndices_Neil_Matched_withBLAAndPFC] = ...
    MatchDataAcrossEpochsNL(chronuxDataStruct_Neil_BLA,chronuxDataStruct_Neil_PFC,...
    epochIndices_Neil_BLA,epochIndices_Neil_PFC,sampleIndices_Neil_BLA);


%% Check TStruct is same across channels for given animal
CheckAcrossChannels({T_Neil_NAcc,T_Neil_NAcc,T_Neil_NAcc},{T_Neil_PFC,T_Neil_PFC,T_Neil_PFC},'compareType','T')

%% Step 12 :Set up coherence analysis
Wtarget = 2;

% Each animal
TChronuxCohgramVal = round(samplerate*1)/samplerate;
TToUse = struct('mountingMale',TChronuxCohgramVal,'huddlingFemale',TChronuxCohgramVal,...
    'huddlingMale',TChronuxCohgramVal,'partnergroomingFemale',TChronuxCohgramVal,...
    'partnergroomingMale',TChronuxCohgramVal,'sniffingFemale',TChronuxCohgramVal,...
    'sniffingMale',TChronuxCohgramVal,'selfgroomingFemale',TChronuxCohgramVal,...
    'bitingFemale',TChronuxCohgramVal,'approachFemale',TChronuxCohgramVal,...
    'approachMale',TChronuxCohgramVal,'rearingFemale',TChronuxCohgramVal);
padToUse = struct;
for i=1:numel(behavNames)
    TToUseBehav=TToUse.(behavNames{i});
    TEpoch = T_Neil_NAcc.(behavNames{i});
    if TToUseBehav>TEpoch
        error('time indicated for coherence is larger than epoch')
    end
    padToUse.(behavNames{i})=15-nextpow2(TToUse.(behavNames{i})*samplerate);  % 2^15 is 32768
end

chronuxDataStructure12Use = chronuxDataStruct_Neil_NAcc_Matched_withPFC;
chronuxDataStructure21Use = chronuxDataStruct_Neil_PFC_Matched_withNAcc;

chronuxDataStructure13Use = chronuxDataStruct_Neil_NAcc_Matched_withBLA;
chronuxDataStructure31Use = chronuxDataStruct_Neil_BLA_Matched_withNAcc;

chronuxDataStructure32Use = chronuxDataStruct_Neil_BLA_Matched_withPFC;
chronuxDataStructure23Use = chronuxDataStruct_Neil_PFC_Matched_withBLA;


% These correspond to each of behavNames
% pad to 32768 (2^15)
paramsmountingMale = struct('pad',padToUse.mountingMale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramshuddlingFemale = struct('pad',padToUse.huddlingFemale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramshuddlingMale = struct('pad',padToUse.huddlingMale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramspartnergroomingFemale = struct('pad',padToUse.partnergroomingFemale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramspartnergroomingMale = struct('pad',padToUse.partnergroomingMale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramssniffingFemale = struct('pad',padToUse.sniffingFemale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramssniffingMale = struct('pad',padToUse.sniffingMale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramsselfgroomingFemale = struct('pad',padToUse.selfgroomingFemale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramsbitingFemale = struct('pad',padToUse.bitingFemale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramsapproachFemale = struct('pad',padToUse.approachFemale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramsapproachMale = struct('pad',padToUse.approachMale,'err',[2 0.05],'trialave',1,'Fs',samplerate);
% paramsrearingFemale = struct('pad',padToUse.rearingFemale,'err',[2 0.05],'trialave',1,'Fs',samplerate);

paramsStruct = struct;
WStruct = struct;
movingwinStruct=struct;

for i=1:numel(behavNames)
    paramsStruct.(behavNames{i})=eval(['params' behavNames{i}]);
    WStruct.(behavNames{i}) = Wtarget;
    movingwinStruct.(behavNames{i})=[TToUse.(behavNames{i}) TToUse.(behavNames{i})/10];
end


for p=1:numel(behavNames)
    movingwinBehav = movingwinStruct.(behavNames{i});
    T = movingwinBehav(1);
    W = WStruct.(behavNames{p});
    TWceilFloor = [ceil(T*W) floor(T*W)];
    TWceilFloorDiff = [abs(TWceilFloor(1)-(T*W)) abs(TWceilFloor(2)-(T*W))];
    [dum,locMin] = min(TWceilFloorDiff);
    TW = TWceilFloor(locMin);
    %TW = max(2,min(TW,10));         % keeps tapers between [2 3] & [10 19]
    W = TW/T                        % actual bandwidth in Hz
    tapers = [TW 2*TW-1]            % display tapers to be used
    paramsStruct.(behavNames{p}).tapers = tapers;
    paramsStruct.(behavNames{p}).fpass = [W samplerate/2-W];
end

% run the coherence analysis with averaging and without averaging

paramsStruct_noavg = paramsStruct;
paramsStruct_noavg.mountingMale.trialave = 0;



%% Step 13: Compute coherogram
coherogramStructNoMeanSTD_NAccPFC = ChronuxMultitaperFunctionsAcrossBehaviorsNL(...
    {chronuxDataStructure12Use},{chronuxDataStructure21Use},paramsStruct,...
    'typeFunction','coherogram','movingwinStruct',movingwinStruct);
coherogramStructNoBiasCorrectionNoTransformNoMeanSTD_NAccPFC = ...
    ChronuxMultitaperFunctionsAcrossBehaviorsNL({chronuxDataStructure12Use},...
    {chronuxDataStructure21Use},paramsStruct,'typeFunction','coherogram',...
    'movingwinStruct',movingwinStruct,'biasCorrectAndTransform','off');
coherogramStructNoMeanSTD_NAccPFC_noavg = ChronuxMultitaperFunctionsAcrossBehaviorsNL(...
    {chronuxDataStructure12Use},{chronuxDataStructure21Use},paramsStruct_noavg,...
    'typeFunction','coherogram','movingwinStruct',movingwinStruct);
coherogramStructNoBiasCorrectionNoTransformNoMeanSTD_NAccPFC_noavg = ...
    ChronuxMultitaperFunctionsAcrossBehaviorsNL({chronuxDataStructure12Use},...
    {chronuxDataStructure21Use},paramsStruct_noavg,'typeFunction','coherogram',...
    'movingwinStruct',movingwinStruct,'biasCorrectAndTransform','off');


coherogramStructNoMeanSTD_NAccBLA = ChronuxMultitaperFunctionsAcrossBehaviorsNL(...
    {chronuxDataStructure13Use},{chronuxDataStructure31Use},paramsStruct,...
    'typeFunction','coherogram','movingwinStruct',movingwinStruct);
coherogramStructNoBiasCorrectionNoTransformNoMeanSTD_NAccBLA = ...
    ChronuxMultitaperFunctionsAcrossBehaviorsNL({chronuxDataStructure13Use},...
    {chronuxDataStructure31Use},paramsStruct,'typeFunction','coherogram',...
    'movingwinStruct',movingwinStruct,'biasCorrectAndTransform','off');
coherogramStructNoMeanSTD_NAccBLA_noavg = ChronuxMultitaperFunctionsAcrossBehaviorsNL(...
    {chronuxDataStructure13Use},{chronuxDataStructure31Use},paramsStruct_noavg,...
    'typeFunction','coherogram','movingwinStruct',movingwinStruct);
coherogramStructNoBiasCorrectionNoTransformNoMeanSTD_NAccBLA_noavg = ...
    ChronuxMultitaperFunctionsAcrossBehaviorsNL({chronuxDataStructure13Use},...
    {chronuxDataStructure31Use},paramsStruct_noavg,'typeFunction','coherogram',...
    'movingwinStruct',movingwinStruct,'biasCorrectAndTransform','off');


coherogramStructNoMeanSTD_BLAPFC = ChronuxMultitaperFunctionsAcrossBehaviorsNL(...
    {chronuxDataStructure32Use},{chronuxDataStructure23Use},paramsStruct,...
    'typeFunction','coherogram','movingwinStruct',movingwinStruct);
coherogramStructNoBiasCorrectionNoTransformNoMeanSTD_BLAPFC = ...
    ChronuxMultitaperFunctionsAcrossBehaviorsNL({chronuxDataStructure32Use},...
    {chronuxDataStructure23Use},paramsStruct,'typeFunction','coherogram',...
    'movingwinStruct',movingwinStruct,'biasCorrectAndTransform','off');
coherogramStructNoMeanSTD_BLAPFC_noavg = ChronuxMultitaperFunctionsAcrossBehaviorsNL(...
    {chronuxDataStructure32Use},{chronuxDataStructure23Use},paramsStruct_noavg,...
    'typeFunction','coherogram','movingwinStruct',movingwinStruct);
coherogramStructNoBiasCorrectionNoTransformNoMeanSTD_BLAPFC_noavg = ...
    ChronuxMultitaperFunctionsAcrossBehaviorsNL({chronuxDataStructure32Use},...
    {chronuxDataStructure23Use},paramsStruct_noavg,'typeFunction','coherogram',...
    'movingwinStruct',movingwinStruct,'biasCorrectAndTransform','off');

%% Step 14: Add means and stds to coherogram structures

coherogramStruct = coherogramStructPostProcessing(coherogramStruct)

% coherogramStruct = coherogramStructNoMeanSTD_NAccPFC;
% coherogramStructNoBiasCorrectionNoTransform = coherogramStructNoBiasCorrectionNoTransformNoMeanSTD;
% 
% % plotCoherogram(coherogramStruct)
% behavNamesCoherogramStruct = fieldnames(coherogramStructNoMeanSTD_NAccPFC);
% behavNamesCoherogramStructNoBiasCorrectionNoTransform = fieldnames(coherogramStructNoBiasCorrectionNoTransformNoMeanSTD);
% if ~isequal(numel(behavNamesCoherogramStruct),numel(behavNamesCoherogramStructNoBiasCorrectionNoTransform))
%     error('inconsistent number of behavior names in coherogramStructNoMeanSTD and coherogramStructNoBiasCorrectionNoTransformNoMeanSTD')
% end
% 
% for i=1:numel(behavNamesCoherogramStruct)
%     behavNameCoherogramStruct =  behavNamesCoherogramStruct{i};
%     if ~isequal(strcmp(behavNameCoherogramStruct,behavNamesCoherogramStructNoBiasCorrectionNoTransform{i}),1)
%         error('inconsistent behavior names between coherogramStructNoMeanSTD and coherogramStructNoBiasCorrectionNoTransformNoMeanSTD')
%     end
%     CValsCoherogram = coherogramStructNoMeanSTD_NAccPFC.(behavNameCoherogramStruct).C;
%     CValsCoherogramNoBiasCorrectionNoTransform = coherogramStructNoBiasCorrectionNoTransformNoMeanSTD.(behavNameCoherogramStruct).C;
%     
%     
%     phiValsCoherogram = coherogramStructNoMeanSTD_NAccPFC.(behavNameCoherogramStruct).phi;
%     phiValsCoherogramNoBiasCorrectionNoTransform = coherogramStructNoBiasCorrectionNoTransformNoMeanSTD.(behavNameCoherogramStruct).phi;
%     if ~isequal(phiValsCoherogram,phiValsCoherogramNoBiasCorrectionNoTransform)
%         error('inconsistent phi')
%     end
%     
%     S12ValsCoherogram = coherogramStructNoMeanSTD_NAccPFC.(behavNameCoherogramStruct).S12;
%     S12ValsCoherogramNoBiasCorrectionNoTransform = coherogramStructNoBiasCorrectionNoTransformNoMeanSTD.(behavNameCoherogramStruct).S12;
%     
%     
%     S1ValsCoherogram = coherogramStructNoMeanSTD_NAccPFC.(behavNameCoherogramStruct).S1;
%     S1ValsCoherogramNoBiasCorrectionNoTransform = coherogramStructNoBiasCorrectionNoTransformNoMeanSTD.(behavNameCoherogramStruct).S1;
%     
%     
%     S2ValsCoherogram = coherogramStructNoMeanSTD_NAccPFC.(behavNameCoherogramStruct).S2;
%     S2ValsCoherogramNoBiasCorrectionNoTransform = coherogramStructNoBiasCorrectionNoTransformNoMeanSTD.(behavNameCoherogramStruct).S2;
%     
%     
%     phistdValsCoherogram = coherogramStructNoMeanSTD_NAccPFC.(behavNameCoherogramStruct).phistd;
%     phistdValsCoherogramNoBiasCorrectionNoTransform = coherogramStructNoBiasCorrectionNoTransformNoMeanSTD.(behavNameCoherogramStruct).phistd;
%     if ~isequal(phistdValsCoherogram,phistdValsCoherogramNoBiasCorrectionNoTransform)
%         error('inconsistent phistd')
%     end
%     
%     coherogramStruct.(behavNameCoherogramStruct).CMean = mean(CValsCoherogram,1); %rows refer to time
%     coherogramStruct.(behavNameCoherogramStruct).CSTD = std(CValsCoherogram,0,1); %rows refer to time
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).CMean = mean(CValsCoherogramNoBiasCorrectionNoTransform,1);
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).CSTD = std(CValsCoherogramNoBiasCorrectionNoTransform,0,1);
%     
%     coherogramStruct.(behavNameCoherogramStruct).phiMean = mean(phiValsCoherogram,1); %rows refer to time
%     coherogramStruct.(behavNameCoherogramStruct).phiSTD = std(phiValsCoherogram,0,1); %rows refer to time
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).phiMean = mean(phiValsCoherogramNoBiasCorrectionNoTransform,1);
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).phiSTD = std(phiValsCoherogramNoBiasCorrectionNoTransform,0,1);
%     
%     coherogramStruct.(behavNameCoherogramStruct).S12Mean = mean(S12ValsCoherogram,1); %rows refer to time
%     coherogramStruct.(behavNameCoherogramStruct).S12STD = std(S12ValsCoherogram,0,1); %rows refer to time
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).S12Mean = mean(S12ValsCoherogramNoBiasCorrectionNoTransform,1);
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).S12STD = std(S12ValsCoherogramNoBiasCorrectionNoTransform,0,1);
%     
%     coherogramStruct.(behavNameCoherogramStruct).S1Mean = mean(S1ValsCoherogram,1); %rows refer to time
%     coherogramStruct.(behavNameCoherogramStruct).S1STD = std(S1ValsCoherogram,0,1); %rows refer to time
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).S1Mean = mean(S1ValsCoherogramNoBiasCorrectionNoTransform,1);
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).S1STD = std(S1ValsCoherogramNoBiasCorrectionNoTransform,0,1);
%     
%     coherogramStruct.(behavNameCoherogramStruct).S2Mean = mean(S2ValsCoherogram,1); %rows refer to time
%     coherogramStruct.(behavNameCoherogramStruct).S2STD = std(S2ValsCoherogram,0,1); %rows refer to time
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).S2Mean = mean(S2ValsCoherogramNoBiasCorrectionNoTransform,1);
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).S2STD = std(S2ValsCoherogramNoBiasCorrectionNoTransform,0,1);
%     
%     coherogramStruct.(behavNameCoherogramStruct).phistdMean = mean(phistdValsCoherogram,1); %rows refer to time
%     coherogramStruct.(behavNameCoherogramStruct).phistdSTD = std(phistdValsCoherogram,0,1); %rows refer to time
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).phistdMean = mean(phistdValsCoherogramNoBiasCorrectionNoTransform,1);
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).phistdSTD = std(phistdValsCoherogramNoBiasCorrectionNoTransform,0,1);
%     
%     CerrNoBiasCorrectNoTransform = coherogramStructNoBiasCorrectionNoTransformNoMeanSTD.(behavNameCoherogramStruct).Cerr;
%     Cerr1NoBiasCorrectNoTransform = squeeze(CerrNoBiasCorrectNoTransform(1,:,:));
%     Cerr2NoBiasCorrectNoTransform = squeeze(CerrNoBiasCorrectNoTransform(2,:,:));
%     Cerr1NoBiasCorrectNoTransformMean = mean(Cerr1NoBiasCorrectNoTransform,1);
%     Cerr1NoBiasCorrectNoTransformSTD = std(Cerr1NoBiasCorrectNoTransform,0,1);
%     Cerr2NoBiasCorrectNoTransformMean = mean(Cerr2NoBiasCorrectNoTransform,1);
%     Cerr2NoBiasCorrectNoTransformSTD = std(Cerr2NoBiasCorrectNoTransform,0,1);
%     
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).CerrMean = [Cerr1NoBiasCorrectNoTransformMean;Cerr2NoBiasCorrectNoTransformMean];
%     coherogramStructNoBiasCorrectionNoTransform.(behavNameCoherogramStruct).CerrSTD = [Cerr1NoBiasCorrectNoTransformSTD;Cerr2NoBiasCorrectNoTransformSTD];
%     
% end
% 


%% Step 15: Show coherence changing over time at PEAK COHER FREQ FOR MATING (intervals over course of experiment)

% Key notes: For individual animals. Before run this part of code, must run
% "Set up coherence analysis" for animal of interest.
% Also note code below is set up to run 1s intervals

clipBounds = [-127.5 127.5]; % from ConvertIndicesToChronuxFormat
damStructTimelineNAcc = damNeil_NAcc;
damStructTimelinePFC = damNeil_PFC;
epochIndicesTimelineNAcc = epochIndices_Neil_NAcc;
epochIndicesTimelinePFC = epochIndices_Neil_PFC;
sampleIndicesTimelineNAcc = sampleIndices_Neil_NAcc;
sampleIndicesTimelinePFC = sampleIndices_Neil_PFC;
sampleRange = ExptRangeSamples_Neil;% from intervals above
sampleMaleAdded = cohabRange(1);
% for freq range: use peak mating integer frequency - be consistent with
% other figures
CMeans = coherogramStruct.mountingMale.CMean;

% identify integer frequency range - from generatefigs_Joe_20150430
if isequal(ceil(min(coherogramStruct.mountingMale.f)),min(coherogramStruct.mountingMale.f))
    rangeFMin = min(coherogramStruct.mountingMale.f)+1;
else
    rangeFMin = ceil(min(coherogramStruct.mountingMale.f));
end

if isequal(floor(max(coherogramStruct.mountingMale.f)),max(coherogramStruct.mountingMale.f))
    rangeFMax = max(coherogramStruct.mountingMale.f)-1;
else
    rangeFMax = floor(max(coherogramStruct.mountingMale.f));
end

rangeF = rangeFMin:rangeFMax; % specify frequency range -- want integer values (see below)
fIDs = zeros(1,numel(rangeF));
for z=1:numel(rangeF)
    fID = find(coherogramStruct.mountingMale.f==rangeF(z)); % find indexes for integer-valued frequencies; padding of data to 32768 (2^15) allows us to select these
    fIDs(z) = fID;
end
CMeansInt=CMeans(fIDs);
[Cmax,IDmax] = max(CMeansInt);
fForTimeline = rangeF(IDmax);



%%  Step 16: Establish set of Chronux params to use in "timeline" coherence analysis (Depends on what behaviors interested in -- see below)

% % Interested in mating, huddling, self-grooming behaviors for now; making sure that
% % params are consistent across those
% if isequal(paramsStruct.mountingMale,paramsStruct.huddlingFemale) && isequal(paramsStruct.mountingMale,paramsStruct.selfgroomingFemale)
     params = paramsStruct.mountingMale;
% else
%     error('params not same between behaviors')
% end

movingwin_mountingMale = movingwinStruct.mountingMale;
% movingwin_selfgroomingFemale = movingwinStruct.selfgroomingFemale;
% movingwin_huddlingFemale = movingwinStruct.huddlingFemale;
% if isequal(movingwin_mountingMale(1),movingwin_selfgroomingFemale(1)) && isequal(movingwin_mountingMale(1),movingwin_huddlingFemale(1))
     tTimelineWindowSeconds = movingwin_mountingMale(1);
% else
%     error('time interval not same between behaviors')
% end
% 
% if isequal(movingwin_mountingMale(2),movingwin_selfgroomingFemale(2)) && isequal(movingwin_mountingMale(2),movingwin_huddlingFemale(2))
     tstepSeconds = movingwin_mountingMale(2);
% else
%     error('time step not same between behaviors')
% end


%% Step 17: Compute coherence over 1 second intervals throughout experiment

startIntervalSample = sampleRange(1); % first interval starts at sampleRange(1)

durationWindowSample = round(tTimelineWindowSeconds*samplerate); % same as cohgramc code and granger causality analysis
durationStepSample = round(tstepSeconds*samplerate); % same as cohgramc code and granger causality analysis

endIntervalSample = sampleRange(1)+durationWindowSample-1; % ending sample of first interval; -1 to include startIntervalSample
timesAndCMeans = [];
timesAndS1Means = [];
timesAndS2Means = [];
timesAndCMeansNoTransform = [];
timesAndS1MeansNoTransform = [];
timesAndS2MeansNoTransform = [];
%S1Cell = {};
%S2Cell = {};
%fMat = [];
%CCell = {};
%percentMove = [];

%numTapersMat = params.tapers;
%numTapers = numTapersMat(2); % how params.tapers is defined: second value is number of tapers
%df = 2*1*numTapers; % 2*numTrials*numTapers; here considering one trial as a window of time
while endIntervalSample<=sampleRange(1,2); % while end of interval is still within the sampleRange; <= because sampleRange(1,2) is often end of experimental session (e.g. cohabitation), which is defined as inclusive
    NAccData = damStructTimelineNAcc.trials.signal(startIntervalSample:endIntervalSample);
    %numel(NAccData)
    PFCData = damStructTimelinePFC.trials.signal(startIntervalSample:endIntervalSample);
    %[startIntervalSample endIntervalSample endIntervalSample-startIntervalSample]
    % Compute coherence only for data segments without clipping, otherwise coherence is set to be NaN; code from
    % ConvertIndicesToChronuxFormat.m
    if ~isempty(find(NAccData==clipBounds(1),1)) || ~isempty(find(NAccData==clipBounds(2),1))|| ~isempty(find(PFCData==clipBounds(1),1))|| ~isempty(find(PFCData==clipBounds(2),1))
        CValIncNoTransform = NaN;
        S1ValIncNoTransform = NaN;
        S2ValIncNoTransform = NaN;
        CValInc = NaN;
        S1ValInc = NaN;
        S2ValInc = NaN;
        %percentMoveVal = NaN;
    else
        [C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(NAccData',PFCData',params);
        % compute average C in theta band
        fTimelineID = find(f==fForTimeline);
        if numel(fTimelineID)>1
            error('should be selecting just one freq id')
        end
        CValIncNoTransform = C(fTimelineID);
        S1ValIncNoTransform = S1(fTimelineID);
        S2ValIncNoTransform = S2(fTimelineID);
        CValInc = atanh(C(fTimelineID)); % Fisher transform; note no bias correction here
        S1ValInc = 10*(log10(S1(fTimelineID))); % log transformed X10 bel-->decibel; note no bias correction here
        S2ValInc = 10*(log10(S2(fTimelineID))); % log transformed X10 bel-->decibel; note no bias correction here
        % for additional analysis by LA 6/23/2014
        %S1Cell = [S1Cell S1];
        %S2Cell = [S2Cell S2];
        %         if isempty(fMat)
        %             fMat = f;
        %         end
    end
    timesAndCMeansNoTransform = [timesAndCMeansNoTransform;startIntervalSample CValIncNoTransform];
    timesAndS1MeansNoTransform = [timesAndS1MeansNoTransform;startIntervalSample S1ValIncNoTransform];
    timesAndS2MeansNoTransform = [timesAndS2MeansNoTransform;startIntervalSample S2ValIncNoTransform];
    timesAndCMeans = [timesAndCMeans;startIntervalSample CValInc]; % keep updating this in each cycle of while loop
    timesAndS1Means = [timesAndS1Means;startIntervalSample S1ValInc];
    timesAndS2Means = [timesAndS2Means;startIntervalSample S2ValInc];
    %percentMove = [percentMove;percentMoveVal];
    % update interval
    startIntervalSample = startIntervalSample+durationStepSample;% using stepped windows
    endIntervalSample = startIntervalSample+durationWindowSample-1; %-1 to include startIntervalSample in interval
end

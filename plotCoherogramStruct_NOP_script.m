% plotCoherogramStruct in script form. To be used in SamplePipeline.m

%% Specifically for O
samplerate = 1.998048780487805e+02;

clear all
clc
cd('C:\Users\ykwon36\Documents\workspace_Jim\O\Analysis_new')
% load in completedRun.mat
load('C:\Users\ykwon36\Documents\workspace_Jim\O\completedRun.mat')

animalID = 'O';
chan1name = 'NAcc';
chan2name = 'PFC';
chan3name = 'BLA';

plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA,animalID,chan1name,chan3name)


plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC_noavg,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC_noavg,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA_noavg,animalID,chan1name,chan3name)

%% run O control epochs
OControlEpochs
animalID = 'OOtherBehavior';
cd('C:\Users\ykwon36\Documents\workspace_Jim\O\AnalysisRandomEpoch_new')

plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA,animalID,chan1name,chan3name)


plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC_noavg,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC_noavg,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA_noavg,animalID,chan1name,chan3name)


%% Specifically for Neil
samplerate = 1.998048780487805e+02;

clear all
clc
cd('C:\Users\ykwon36\Documents\workspace_Jim\Neil\Analysis_new')

% load in completedRun.mat
load('C:\Users\ykwon36\Documents\workspace_Jim\Neil\completedRun.mat')

animalID = 'Neil';
chan1name = 'NAcc';
chan2name = 'PFC';
chan3name = 'BLA';

plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA,animalID,chan1name,chan3name)


plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC_noavg,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC_noavg,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA_noavg,animalID,chan1name,chan3name)

%% run Neil control epochs
NeilControlEpochs
animalID = 'NeilOtherBehavior';
cd('C:\Users\ykwon36\Documents\workspace_Jim\Neil\AnalysisRandomEpoch_new')

plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA,animalID,chan1name,chan3name)


plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC_noavg,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC_noavg,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA_noavg,animalID,chan1name,chan3name)


%% run Paul

samplerate = 1.998048780487805e+02;

clear all
clc
cd('C:\Users\ykwon36\Documents\workspace_Jim\Paul\Analysis_new')

% load in completedRun.mat
load('C:\Users\ykwon36\Documents\workspace_Jim\Paul\completedRun.mat')

animalID = 'Paul';
chan1name = 'NAcc';
chan2name = 'PFC';
chan3name = 'BLA';

plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA,animalID,chan1name,chan3name)


plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC_noavg,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC_noavg,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA_noavg,animalID,chan1name,chan3name)

%% run Paul control epochs
PaulControlEpochs
animalID = 'PaulOtherBehavior';
cd('C:\Users\ykwon36\Documents\workspace_Jim\Paul\AnalysisRandomEpoch_new')

plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA,animalID,chan1name,chan3name)


plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC_noavg,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC_noavg,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA_noavg,animalID,chan1name,chan3name)


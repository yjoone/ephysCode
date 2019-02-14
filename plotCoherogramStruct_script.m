% plotCoherogramStruct in script form. To be used in SamplePipeline.m

animalID = 'PaulOtherBehavior';
chan1name = 'NAcc';
chan2name = 'PFC';
chan3name = 'BLA';

plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA,animalID,chan1name,chan3name)


plotCoherogramStruct(coherogramStructNoMeanSTD_NAccPFC_noavg,animalID,chan1name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_BLAPFC_noavg,animalID,chan3name,chan2name)
plotCoherogramStruct(coherogramStructNoMeanSTD_NAccBLA_noavg,animalID,chan1name,chan3name)
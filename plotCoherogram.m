function plotCoherogram(coherogramStruct,chan1name,chan2name,varargin)

% this function takes in coherogramStruct, which is the output after
% SamplePipeline.m script step 14. 

% in case behaviorName and outName is different, this can be used to
% specify output name. (ie. varargin = [{outName},{NeilOther}];)

% Hard coded for mountingMale behavior. 

behaviorName = 'mountingMale';
outName = behaviorName;

assign(varargin{:})


%% unload data
% dataStruct = coherogramStruct.(behaviorName);
f = coherogramStruct.(behaviorName).f;
C = coherogramStruct.(behaviorName).C;
S1 = coherogramStruct.(behaviorName).S1;
S2 = coherogramStruct.(behaviorName).S2;

[ntrial,~] = size(C);

%% plot Coherence with biascorrection, transform, meanSTD

figure; 
imagesc(f,ntrial,C);
title(['Coherence ' outName])
xlabel('Frequency (Hz)')
ylabel('Trials')

outfilepath = cd;
outfilename = ['Coherence_' outName];

savefigure(fh,outfilepath,outfilename,varargin)
close(gcf)

%% plot Multitaper power with biascorrection, transform, meanSTD

figure; 
imagesc(f,ntrial,S1);
title(['Power Multitaper ' chan1name ' ' outName])
xlabel('Frequency (Hz)')
ylabel('Trials')

outfilepath = cd;
outfilename = ['Power_Multitaper' chan1name ' ' outName];

savefigure(fh,outfilepath,outfilename,varargin)
close(gcf)

%% plot Multitaper power with biascorrection, transform, meanSTD

figure; 
imagesc(f,ntrial,S2);
title(['Power Multitaper ' chan2name ' ' outName])
xlabel('Frequency (Hz)')
ylabel('Trials')

outfilepath = cd;
outfilename = ['Power_Multitaper' chan2name ' ' outName];

savefigure(fh,outfilepath,outfilename,varargin)
close(gcf)

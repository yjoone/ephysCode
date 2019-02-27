function plotModStructEachAnimal(animalID,expdatapath,varargin)

% set default variables
samplerate = 1.998048780487805e+02;
chan1name = 'NAcc';
chan2name = 'PFC';
chan3name = 'BLA';
outfoldername = 'CFCAnalysis'
assign(varargin{:})

% set current directory
cd([expdatapath '\' animalID])
outfilepath = fullfile(cd,outfoldername);

% set outfilepath
if ~isdir(outfilepath)
    mkdir(outfilepath)
end


% load in completedCFCRun.mat
load([expdatapath '\' animalID '\completedCFCRun.mat'])

freqlow = flow;
freqhigh = fhigh;

modStruct = plotModStruct(modStruct,freqhigh,freqlow,animalID,outfilepath)
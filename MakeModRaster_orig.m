function [modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = MakeModRaster(dam,startLastRangeSamples,chanNameCellPhaseFreq,chanNameCellAmpFreq,dataAcq,varargin)
% Create a raster of modulation index (MI) values
%
% Key Note: all sample indices referenced below are matched to neural data
%
% Inputs:
%   dam (struct): stores neural data (samples) and sample indices
%   corresponding to behaviors. Fieldnames of "signal" and
%   "neuralidsbehavs" (optional: if specifyBehavs variable, below, set to true). e.g. 
%       dam.signal.NAcc <row vector with nucleus accumbens data (samples)>
%       dam.signal.PFC <row vector with prefrontal cortex data (samples)>
%       dam.neuralidsbehavs.mountingMale <row vector with sample indices
%       corresponding to behaviors (optional)>
%
%   samplerate (double): neural data sampling rate
%
%   startLastRangeSamples (vector array): sample indices specifying range over which to compute raster (inclusive)
%
%   chanNameCellPhaseFreq (cell array of strings): specifying channels to
%   use as low- (phase) frequency signal. Each string must match a
%   fieldname of dam.signal. e.g. {'PFC','NAcc'}
%
%   chanNameCellAmpFreq (cell array of strings): (matched to
%   chanNameCellPhaseFreq) specifying channels to use as high- (amplitude)
%   frequency signal. Each string must match a fieldname of dam.signal.
%   e.g. {'NAcc','PFC'}
%
%   dataAcq (string): system for acquiring data (e.g. 'TDT','NL')
%
% Outputs:
%   modStruct (struct): MI raster values
%   fieldnames are each combination of phase and amplitude frequency channels specified in
%   chanNameCellPhaseFreq and chanNameCellAmpFreq. e.g.
%       modStruct.PFCtoNAcc
%       modStruct.NAcctoPFC
%   a further extension of .all corresponds to all modulation raster values
%   Output from .all is in the form of [a x b x c] where a and b correspond to
%   flow and fhigh values (see below), respectively, and c corresponds to given time
%   index.
%
%   rasterWindoTimesSamplesStruct (struct): structure listing sample indices of
%   raster windows (each row is a window; first column is start index of window;
%   second colum is last index of window [inclusive])
%
%   flow (vector array): set of phase frequencies used in MI analysis
%
%   fhigh (vecotry array): set of amplitude frequencies used in MI analysis


specifyBehavs = false; %true; 
windowSizeSeconds = 5;
% windowSizeSeconds = 20;
windowType = 'noneOverlap'; %'overlap'
windowStepSeconds = windowSizeSeconds/10;
intersectBehavType = 'full'; %partial
plot = 'y';
flowStep = 1;
fhighStep = 4;
flow = 3:flowStep:21;
fhigh = 12:fhighStep:84;
flowBandPlusMinus = flowStep/2;
fhighBandPlusMinus = fhighStep/2;
assign(varargin{:});

samplerate=dam.samplerate;

modStruct = struct;
rasterWindowTimesSamplesStruct = struct;
rasterWindowTimesSamples = [];
windowSizeSamples = round(windowSizeSeconds*samplerate); 
windowStepSamples = round(windowStepSeconds*samplerate);
chanNames = fieldnames(dam.signal);
switch specifyBehavs
    case true
        behavNames = fieldnames(dam.neuralidsbehavs);
end
numChans = numel(chanNames);

if ~isequal(numel(chanNameCellPhaseFreq),numel(chanNameCellAmpFreq))
    error('phase freq and amp freq cells should be matched in size')
end

% verify chanNameCellPhaseFreq and chanNameCellAmpFreq are members of
% chanNames
for i=1:numel(chanNameCellPhaseFreq)
    if ~ismember(chanNameCellPhaseFreq{i},chanNames)
        error('chanNameCellPhaseFreq contains at least one name different from chanNames')
    end
    if ~ismember(chanNameCellAmpFreq{i},chanNames)
        error('chanNameCellAmpFreq contains at least one name different from chanNames')
    end
end

switch dataAcq
    case 'NL'
        clipRange = [-127.5 127.5]; % clipRange(1) < data < clipRange(2)
    case 'TDT' % fill in for TDT
        clipRange = [-inf inf];%is there a clipping range in TDT? 
end

% extract data within specified range
dataInRange = struct;
for i=1:numChans
    datai = dam.signal.(chanNames{i});
    dataInRange.(chanNames{i}) = datai(startLastRangeSamples(1):startLastRangeSamples(2));
end
sizeRangeSamples = numel(dataInRange.(chanNames{1}));

% establish window indices 
startIndex = 1;
lastIndex = startIndex+windowSizeSamples-1;
if lastIndex > sizeRangeSamples
    error('numel of data in range smaller than window size')
end
while lastIndex<=sizeRangeSamples
    rasterWindowTimesSamples = [rasterWindowTimesSamples;startLastRangeSamples(1)+startIndex-1 startLastRangeSamples(1)+lastIndex-1];
    switch windowType
        case 'noneOverlap'
            startIndex = lastIndex+1;
            lastIndex = startIndex+windowSizeSamples-1;
        case 'overlap'
            startIndex = startIndex+windowStepSamples;
            lastIndex = lastIndex+windowStepSamples;
    end
end

rasterWindowTimesSamplesStruct.all = rasterWindowTimesSamples;

switch specifyBehavs
    case true
        % determine which window indices overlap with behaviors
        winsBehavs = struct;
        for i=1:numel(behavNames)
            behavWinYes = [];
            behavNamei = behavNames{i};
            neuralSamplesBehavs = dam.neuralidsbehavs.(behavNamei);
            for j=1:size(rasterWindowTimesSamples,1)
                starttoLastSamples = rasterWindowTimesSamples(j,1):rasterWindowTimesSamples(j,2);
                switch intersectBehavType
                    case 'full'
                        testIsMember = ismember(starttoLastSamples,neuralSamplesBehavs);
                        if isequal(sum(testIsMember),numel(testIsMember))
                            behavWinYes = [behavWinYes j];
                        end
                    case 'partial'
                        if ~isempty(intersect(starttoLastSamples,neuralSamplesBehavs))
                            behavWinYes = [behavWinYes j];
                        end
                end
            end
            winsBehavs.(behavNamei) = behavWinYes;     
        end
        
        for k=1:numel(behavNames)
            behavNamek = behavNames{k};
            rasterWindowTimesSamplesStruct.(behavNamek) = rasterWindowTimesSamples(winsBehavs.(behavNamek),:);
        end
end

% compute Modulation Index over all windows
for i=1:numel(chanNameCellPhaseFreq);
    dataChanPhaseFreq = dam.signal.(chanNameCellPhaseFreq{i});
    dataChanAmpFreq = dam.signal.(chanNameCellAmpFreq{i});
    mod2dValsChans = zeros(numel(flow),numel(fhigh),size(rasterWindowTimesSamples,1)); % row is low freq, column is high freq
    for j=1:size(rasterWindowTimesSamples,1)
        dataChanPhaseFreqWin = dataChanPhaseFreq(rasterWindowTimesSamples(j,1):rasterWindowTimesSamples(j,2));
        dataChanAmpFreqWin = dataChanAmpFreq(rasterWindowTimesSamples(j,1):rasterWindowTimesSamples(j,2));
        if isempty(find(dataChanPhaseFreqWin<=clipRange(1),1)) &&  isempty(find(dataChanPhaseFreqWin>=clipRange(2),1)) && isempty(find(dataChanAmpFreqWin<=clipRange(1),1)) &&  isempty(find(dataChanAmpFreqWin>=clipRange(2),1))
            [mod2dChans,phasepref2dChans] = KL_MI2d(dataChanPhaseFreqWin,dataChanAmpFreqWin,flow,fhigh,flowBandPlusMinus,fhighBandPlusMinus,samplerate,'n');
            mod2dValsChans(:,:,j) = mod2dChans;
        else
            mod2dValsChans(:,:,j) = NaN*ones(numel(flow),numel(fhigh)); % insert NaNs for windows with clipping
        end
    end
    
    modStruct.([chanNameCellPhaseFreq{i},'to',chanNameCellAmpFreq{i}]).all = mod2dValsChans;
    
    % index mod2dVals corresponding with behaviors
    switch specifyBehavs
        case true
            for k=1:numel(behavNames)
                behavNamek = behavNames{k};
                modStruct.([chanNameCellPhaseFreq{i},'to',chanNameCellAmpFreq{i}]).(behavNamek) = mod2dValsChans(:,:,winsBehavs.(behavNamek));
            end
    end
end





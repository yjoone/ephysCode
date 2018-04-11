function [coherenceStruct,S1Struct,S2Struct,rasterWindowTimesSamplesStruct,fSpect] = MakeCoherenceRaster(dam,startLastRangeSamples,chanNameCell1,chanNameCell2,dataAcq,varargin)

specifyBehavs = true; 
windowType = 'overlap'; %'overlap' 'noneOverlap'
intersectBehavType = 'full'; %partial
plot = 'y';
windowTargetSizeSeconds = 1;
W = 2; % Hz
windowStepMultiplierTargetSize = 1/10;
keepFrequenciesRange = [3 100]; % Hz; monotonic; inclusive
PerformTransform = 'on';

assign(varargin{:});

samplerate=dam.samplerate;

% establish coherence params
params = struct;
windowSizeSeconds = round(samplerate*windowTargetSizeSeconds)/samplerate;
windowSizeSamples = round(windowSizeSeconds*samplerate); 
% if ~isequal(round(windowSizeSeconds*samplerate),(windowSizeSeconds*samplerate))
%     error('window specified incorreclty')
% end

% pad to get integer freq resolution
switch dataAcq
    case 'NL'
        params.pad = 15-nextpow2(windowSizeSamples);  % N=2^15 is 32768; use to get integer freq (samplerate/N is bin spacing)
    case 'TDT'
        params.pad = 0; %0:next power of 2 % padding for TDT?
end
params.err = [2 0.05];
params.trialave = 1;
params.Fs = samplerate;

TWceilFloor = [ceil(windowSizeSeconds*W) floor(windowSizeSeconds*W)];
TWceilFloorDiff = [abs(TWceilFloor(1)-(windowSizeSeconds*W)) abs(TWceilFloor(2)-(windowSizeSeconds*W))];
[~,locMin] = min(TWceilFloorDiff);
TW = TWceilFloor(locMin);
W = TW/windowSizeSeconds                        % actual bandwidth in Hz
tapers = [TW 2*TW-1]          % display tapers to be used
params.tapers = tapers;
fpassVar = [W samplerate/2-W];
if keepFrequenciesRange(1)<fpassVar(1) || keepFrequenciesRange(end)>fpassVar(2)
    error('keepFrequenciesRange should be within range specified by fpassVar')
end
params.fpass = [keepFrequenciesRange(1) keepFrequenciesRange(end)];

% initialize variables
coherenceStruct = struct;
S1Struct = struct;
S2Struct = struct;
rasterWindowTimesSamplesStruct = struct;
rasterWindowTimesSamples = [];

%isequal(round(windowSizeSeconds*samplerate),windowSizeSeconds*samplerate)

windowStepSeconds = windowSizeSeconds*windowStepMultiplierTargetSize;
windowStepSamples = round(windowStepSeconds*samplerate);
chanNames = fieldnames(dam.signal);
switch specifyBehavs
    case true
        behavNames = fieldnames(dam.neuralidsbehavs);
end
numChans = numel(chanNames);

if ~isequal(numel(chanNameCell1),numel(chanNameCell2))
    error('chanNameCell1 and chanNameCell2 should be matched in size')
end

% verify chanNameCell1 and chanNameCell2 are members of
% chanNames
for i=1:numel(chanNameCell1)
    if ~ismember(chanNameCell1{i},chanNames)
        error('chanNameCell1 contains at least one name different from chanNames')
    end
    if ~ismember(chanNameCell2{i},chanNames)
        error('chanNameCell2 contains at least one name different from chanNames')
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

% compute coherence over all windows
for i=1:numel(chanNameCell1);
    dataChanName1 = dam.signal.(chanNameCell1{i}); 
    dataChanName2 = dam.signal.(chanNameCell2{i}); 
    
    dataChanName1Test = dataChanName1(rasterWindowTimesSamples(1,1):rasterWindowTimesSamples(1,2))'; % column form for Chronux
    dataChanName2Test = dataChanName2(rasterWindowTimesSamples(1,1):rasterWindowTimesSamples(1,2))'; % column form for Chronux
    [~,~,~,~,~,fSpect,~,~,~]=coherencyc(dataChanName1Test,dataChanName2Test,params);
    
    coherenceValsChans = zeros(size(rasterWindowTimesSamples,1),numel(fSpect)); % row is time point, columns correspond to frequencies to keep
    S1ValsChans = zeros(size(rasterWindowTimesSamples,1),numel(fSpect)); % row is time point, columns correspond to frequencies to keep
    S2ValsChans = zeros(size(rasterWindowTimesSamples,1),numel(fSpect)); % row is time point, columns correspond to frequencies to keep
    for j=1:size(rasterWindowTimesSamples,1)
        dataChanName1Win = dataChanName1(rasterWindowTimesSamples(j,1):rasterWindowTimesSamples(j,2))'; % column form for Chronux
        dataChanName2Win = dataChanName2(rasterWindowTimesSamples(j,1):rasterWindowTimesSamples(j,2))'; % column form for Chronux
        if isempty(find(dataChanName1Win<=clipRange(1),1)) &&  isempty(find(dataChanName1Win>=clipRange(2),1)) && isempty(find(dataChanName2Win<=clipRange(1),1)) &&  isempty(find(dataChanName2Win>=clipRange(2),1))
            [C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(dataChanName1Win,dataChanName2Win,params);
            if strcmp(PerformTransform,'on')
                CValsfIDs = atanh(C); % Fisher transform; note no bias correction here 
                S1ValsfIDs = 10*(log10(S1)); % log transformed X10 bel-->decibel; note no bias correction here 
                S2ValsfIDs = 10*(log10(S2)); % log transformed X10 bel-->decibel; note no bias correction here 
            else
                CValsfIDs = C;
                S1ValsfIDs = S1;
                S2ValsfIDs = S2;
            end
            coherenceValsChans(j,:) = CValsfIDs;
            S1ValsChans(j,:) = S1ValsfIDs;
            S2ValsChans(j,:) = S2ValsfIDs;
        else
            coherenceValsChans(j,:) = NaN*ones(1,numel(fSpect)); % insert NaNs for windows with clipping
            S1ValsChans(j,:) = NaN*ones(1,numel(fSpect));
            S2ValsChans(j,:) = NaN*ones(1,numel(fSpect));
        end
    end
    
    coherenceStruct.([chanNameCell1{i},'with',chanNameCell2{i}]).all = coherenceValsChans;
    S1Struct.([chanNameCell1{i},'with',chanNameCell2{i}]).all = S1ValsChans;
    S2Struct.([chanNameCell1{i},'with',chanNameCell2{i}]).all = S2ValsChans;
    
    % index coherence corresponding with behaviors
    switch specifyBehavs
        case true
            for k=1:numel(behavNames)
                behavNamek = behavNames{k};
                coherenceStruct.([chanNameCell1{i},'with',chanNameCell2{i}]).(behavNamek) = coherenceValsChans(winsBehavs.(behavNamek),:);
                S1Struct.([chanNameCell1{i},'with',chanNameCell2{i}]).(behavNamek) = S1ValsChans(winsBehavs.(behavNamek),:);
                S2Struct.([chanNameCell1{i},'with',chanNameCell2{i}]).(behavNamek) = S2ValsChans(winsBehavs.(behavNamek),:);
            end
    end
end
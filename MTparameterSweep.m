% test script for mtspecgramc parameter sweeping

%% for mtspectrumc param input. Refer to the manual for detailed description.
% A numeric vector [W T p] where W is the
% bandwidth, T is the duration of the data and p
% is an integer such that 2TW-p tapers are used. In
% this form there is no default i.e. to specify
% the bandwidth, you have to specify T and p as
% well. Note that the units of W and T have to be
% consistent: if W is in Hz, T must be in seconds
% and vice versa. Note that these units must also
% be consistent with the units of params.Fs: W can
% be in Hz if and only if params.Fs is in Hz.
% The default is to use form 1 with TW=3 and K=5

% set data parameters and load the data to a new structure
channel = 'BLA';
behav = 'mountingMale';
params.pad = 7;
params.err = [2, .05];
params.trialave = 1;

% multitaper parameters
W = 0.4:0.1:3;
T = NaN; % to be computed later per each epoch
p = 1;

eval(['damStruct = damNeil_' channel ';']);
%% unload the data
signal = damStruct.trials.signal;
behvindstruct = damStruct.trials.behavindices;
samplerate = damStruct.param.samplerate;

% add sample rate to the param struct
params.Fs = samplerate;



% get the data for specific behavior indices
behvind = behvindstruct.(behav);
[r,~] = size(behvind);

% initialize the output structure, and loop through each behavior epoch
behdataStruct = struct;
for i = 1:r
    ind = behvind(i,:);
    behdata = signal(ind(1):ind(2));
    behdataStruct.rawdata{i} = behdata;
end


%% set multi taper parameters based on above description

% params = [W T p];

MTstruct = struct;
for wi = 1:length(W)
    for epoch = 1:r
        behdata = behdataStruct.rawdata{epoch};
        T = length(behdata)/samplerate;
        params.tapers = [W(wi) T p];
        [S{epoch,wi},f{epoch,wi},Serr{epoch,wi}]=mtspectrumc(behdata,params);
        if rem(10,epoch) == 0
            disp(['Finished MT for ' num2str(epoch) ' out of ' num2str(r) ', in window ' num2str(wi) ' out of ' num2str(length(W))])
        end
    end
end
MTStruct.W = W;
MTStruct.S = S;
MTStruct.f = f;
MTStruct.Serr = Serr;
MTStruct.data = behdataStruct;
MTStruct.params = params;

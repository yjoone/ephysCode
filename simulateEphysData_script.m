% script to generate simulated data for analysis pipeline testing
power = 10;
samplerate = 200;
targetfreq = 40;
wtarget = 2;
pad = 7;
err = [2 .05];
t = 0:0.005:1000;
y = 10*sin(t*2*pi*targetfreq);
noise = rand(numel(t),1)';
sig = y+noise;

%% pwelch
figure; pwelch(sig,[],[],[],samplerate)

%% multitaper method
T = [1.01];
W = wtarget;
TWceilFloor = [ceil(T*W) floor(T*W)];
TWceilFloorDiff = [abs(TWceilFloor(1)-(T*W)) abs(TWceilFloor(2)-(T*W))];
[dum,locMin] = min(TWceilFloorDiff);
TW = TWceilFloor(locMin);
tapers = [TW 2*TW-1]; %should be [2 3]
% params.tapers = tapers;
params.tapers = [5 3];
params.pad = pad;
params.Fs = samplerate;
params.fpass = [W samplerate/2-W];
params.trialave = 0;
params.err = err;

[C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(sig,sig,params);

figure; plot(f,S1);
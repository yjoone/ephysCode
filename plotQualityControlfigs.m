function plotQualityControlfigs(data,dataID,outfilepath)

% This function takes in a 1 by n timeseries data and plots the raw trace,
% power density spectrum, and save those figures in outfilepath folder.

sampleRate = 400;
psdrange = [3e6,10e6]; % this range was set to just take in recordings from cohab.
    % adjust accordingly based on sample rate, experiment duration. Get it
    % from the raw trace to specify a region.
%% plot the raw trace
fh = figure;
plot(data);
xlabel('samples at 400Hz')
ylabel('signal')
title([dataID ' Raw trace'])
fname = [dataID '_rawtrace'];
savefig(fh,fullfile(outfilepath,fname));
print(fh,[fullfile(outfilepath,fname) '.png'],'-dpng')


%% plot the power density spectrum
fh2 = figure;
pwelch(data(psdrange(1):psdrange(2)),[],[],[],sampleRate);

title([dataID ' power density spectrum'])
fname = [dataID '_psd'];
savefig(fh,fullfile(outfilepath,fname));
print(fh,[fullfile(outfilepath,fname) '.png'],'-dpng')
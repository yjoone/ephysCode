function [powerdata] = runPowerSpectraAnalysis(damStruct,Chan,behaviors,outfilepath,varargin)

% this function takes in an organized dam struct, after step 5 of the
% Samplepipeline.m. It computes the power spectral analysis and saves the
% figures in the specified path

% currently programmed to run only mountingMale behavior. Fit in
% flexibility later on. JK 010719

%% defaults
% behaviors = 'mountingMale';
% behaviors = 'other';
nfft = 1024; 
%This is to ensure the power spectrum output has same length across
%different epoches of behavior
samplerate = 199.8049; % add this to the damStruct so it travels with data.
assign(varargin);

%% create the analysis folder if it does not exist yet
if ~exist(fullfile(outfilepath,'Analysis'))
    mkdir(fullfile(outfilepath,'Analysis'));
    outfilepath = fullfile(outfilepath,'Analysis');
else
    outfilepath = fullfile(outfilepath,'Analysis');
end

%% unload the data
signal = damStruct.trials.signal;
behInd = [damStruct.trials.behavindices.(behaviors)];

%% run the power analysis for each behavior indices
[nbeh,~] = size(behInd);

for i = 1:nbeh
    data = signal(behInd(i,1):behInd(i,2));
    [pxx,f,pxxc] = pwelch(data,[],[],nfft,samplerate);
    powerdata.pxx(i,:) = pxx;
    powerdata.f(i,:) = f;
    % powerdata.pxxc(i,:) = pxxc;
    
    
    %% plot the power spectra figure
    figure; plot(f,10*log10(pxx));
    title(['PowerSpectrum_' damStruct.animal ' ' Chan ' ' ...
        num2str(damStruct.exptdate) ' ' behaviors num2str(i)])
    
    outfilename = ['PowerSpectrum_' damStruct.animal '_' Chan '_' ...
        num2str(damStruct.exptdate) '_' behaviors num2str(i)];
    savefigure(gcf,outfilepath,outfilename)
    close(gcf)
end

%% compute the average for this animal
mpxx = mean(pxx,2);

figure; plot(f,10*log10(mpxx));
title(['PowerSpectrum_' damStruct.animal ' ' Chan ' ' ...
    num2str(damStruct.exptdate) ' ' behaviors ' All'])

outfilename = ['PowerSpectrum_' damStruct.animal '_' Chan '_' ...
    num2str(damStruct.exptdate) '_' behaviors '_All'];
savefigure(gcf,outfilepath,outfilename)
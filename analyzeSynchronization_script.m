% script to analyze synchronization between video LED signal and neural IR
% LED signal

% This script will use data from Franz, Habituation1

outfilepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Synchronization';
LEDthresh = 240;

% Load the data
load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Habituation1_rawData.mat')
load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Videos\Habituation1\LEDbySamepleTimes.mat')
    % note that the LED extracted data is an output from extractLEDsignal.m
    
% visualize LED data
figure; 
plot(LED,'.')
title('LED signal from video recording')
xlabel('Frames')
ylabel('on - 255/ off 0')
outfilename = 'LED_data_raw';
savefigure(gcf,outfilepath,outfilename);

% zoom in the LED data to the 255 area to establish a cut off
set(gca,'ylim',[230 260]);
outfilename = 'LED_data_raw_zoomed';
savefigure(gcf,outfilepath,outfilename);

% identify all LED 'on' points, based on above threshold
LEDi = LED > LEDthresh;


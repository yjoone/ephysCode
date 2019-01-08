% script to extract LED indicator light on

% video location & LED location
% filepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Videos\Habituation1';
% filename = '2018-09-20 18_39_02.avi';
filepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Neil'
filename = 'Habituation2_and_Cohab_Neil_113018.avi';
% LEDpos = [213+23,541+21];
% LEDpos = [183, 183];
% LEDpos = [409,27]; % LA sample pipeline video. JK 122918
LEDpos = [181,182]; %for Neil Cohab. JK
rbgChan = 1; % RBG in channel 123 respectively

% set up the video object
fullfilepath = fullfile(filepath,filename);
v = VideoReader(fullfilepath);


% load in the video frame by frame and extract the LED light brightness
i = 1;
while hasFrame(v)
    I_temp = readFrame(v);
    LED(i) = I_temp(LEDpos(1),LEDpos(2),1);
    i = i+1;
end

figure;
plot(LED,'.')
title('LED activity during recording')
xlabel('Samples (NL sample)')
ylabel('Red channel brightness')

% save the data and figure
save(fullfile(filepath,'LEDbySamepleTimes.mat'),'LED');
savefig(fullfile(filepath,'LEDbySamepleTimes.fig'));
print(gcf,fullfile(filepath,'LEDbySamepleTimes.png'),'-dpng')
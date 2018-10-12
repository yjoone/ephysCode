% script to extract LED indicator light on

% video location & LED location
filepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Videos\Habituation1';
filename = '2018-09-20 18_39_02.avi';
LEDpos = [213+23,541+21];
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
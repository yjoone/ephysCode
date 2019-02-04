% this script is to generate figures for the neurologger mechanical
% connection testing


NLname = 'Geoff';
% NLname = 'NY';

filepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Karl\Habituation1_Karl_101718.hex';

% outfilepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL';
outfilepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Karl';

% add the code path for neurologger import function
addpath('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\ephysCode')



[datacell,samplerate] = readNL_gka(filepath);

% get the number of recordings. Each recording will be stored as an
% individual cell in datacell
recnum = length(datacell);

% run each recording
for rec_i = 1:recnum
    testingData = datacell{rec_i};
    xlim = 1:length(testingData);
    
    % create a single figure window with subplots. Total of 8 channels
    figure;
    for i = 1:8
        channel = i;
        subplot(3,3,i)
        plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
        xlabel('Time (s)')
        title(['Neurologger Channel ' num2str(channel)]);
    end
    
    savefig(gcf,fullfile(outfilepath,['NeurologgerSignal_' NLname '_datacell' num2str(rec_i) '.fig']))
    print(gcf,fullfile(outfilepath,['NeurologgerSignal_' NLname '_datacell' num2str(rec_i) '.png']),'-dpng')
end

% 
% channel = 1;
% figure; 
% plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
% xlabel('Time (s)')
% title(['Neurologger Channel ' num2str(channel)]);
% savefig(gcf,fullfile(outfilepath,['channelGround.fig']))
% print(gcf,fullfile(outfilepath,['channelGround.png']),'-dpng')
% close(gcf)
% 
% channel = 2;
% figure; 
% plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
% xlabel('Time (s)')
% title(['Neurologger Channel ' num2str(channel)]);
% savefig(gcf,fullfile(outfilepath,['channel' num2str(channel) '.fig']))
% print(gcf,fullfile(outfilepath,['channel' num2str(channel) '.png']),'-dpng')
% close(gcf)
% 
% channel = 3;
% figure; 
% plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
% xlabel('Time (s)')
% title(['Neurologger Channel ' num2str(channel)]);
% savefig(gcf,fullfile(outfilepath,['channel' num2str(channel) '.fig']))
% print(gcf,fullfile(outfilepath,['channel' num2str(channel) '.png']),'-dpng')
% close(gcf)
% 
% channel = 4;
% figure; 
% plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
% xlabel('Time (s)')
% title(['Neurologger Channel ' num2str(channel)]);
% savefig(gcf,fullfile(outfilepath,['channel' num2str(channel) '.fig']))
% print(gcf,fullfile(outfilepath,['channel' num2str(channel) '.png']),'-dpng')
% close(gcf)
% 
% channel = 5;
% figure; 
% plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
% xlabel('Time (s)')
% title(['Neurologger Channel ' num2str(channel)]);
% savefig(gcf,fullfile(outfilepath,['channel' num2str(channel) '.fig']))
% print(gcf,fullfile(outfilepath,['channel' num2str(channel) '.png']),'-dpng')
% close(gcf)
% 
% channel = 6;
% figure; 
% plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
% xlabel('Time (s)')
% title(['Neurologger Channel ' num2str(channel)]);
% savefig(gcf,fullfile(outfilepath,['channel' num2str(channel) '.fig']))
% print(gcf,fullfile(outfilepath,['channel' num2str(channel) '.png']),'-dpng')
% close(gcf)
% 
% channel = 7;
% figure; 
% plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
% xlabel('Time (s)')
% title(['Neurologger Channel ' num2str(channel)]);
% savefig(gcf,fullfile(outfilepath,['channel' num2str(channel) '.fig']))
% print(gcf,fullfile(outfilepath,['channel' num2str(channel) '.png']),'-dpng')
% close(gcf)
% 
% channel = 8;
% figure; 
% plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
% xlabel('Time (s)')
% title(['Neurologger Channel ' num2str(channel)]);
% savefig(gcf,fullfile(outfilepath,['channel' num2str(channel) '.fig']))
% print(gcf,fullfile(outfilepath,['channel' num2str(channel) '.png']),'-dpng')
% close(gcf)
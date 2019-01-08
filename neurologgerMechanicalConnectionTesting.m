% this script is to generate figures for the neurologger mechanical
% connection testing

filepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\NLTroubleShooting\Data\Greg_Postmortem_Testing_083118.hex';
% filepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\NLTroubleShooting\NeurologgerMechanicalConnectionTest2_080618.hex';
% filepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\NLTroubleShooting\NeurologgerMechanicalConnectionTest_080618.hex';
outfilepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\NLTroubleShooting';
% add the code path for neurologger import function
addpath('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\ephysCode')

[datacell,samplerate] = readNL_gka(filepath);

testingData = datacell{2};
% testingData = datacell{1};
% xlim = 3.2e5:3.9e5; % change it based on each recording
xlim = 1:length(testingData);
% xlim = [1:(1.7e4*200)];

% create a single figure window with subplots. Total of 8 channels
figure;
for i = 1:8
    channel = i;
    subplot(3,3,i)
    plot((0:length(testingData(channel,xlim))-1)/samplerate,testingData(channel,xlim))
    xlabel('Time (s)')
    title(['Neurologger Channel ' num2str(channel)]);
end

savefig(gcf,fullfile(outfilepath,['NeurologgerSignal.fig']))
print(gcf,fullfile(outfilepath,['NeurologgerSignal.png']),'-dpng')

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
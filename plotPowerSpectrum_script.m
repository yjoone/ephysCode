

% plot pwelch for channel 3~5
SampleRate = 200;
outfilepath = cd;

%% plot the power spectrums
figure; pwelch(chan3,[],[],[],SampleRate)

title('Karl Cohabitation mPFC power spectrum')

savefigure(gcf,outfilepath,'Karl_Cohab_mPFC_Power');


figure; pwelch(chan4,[],[],[],SampleRate)

title('Karl Cohabitation NAcc power spectrum')

savefigure(gcf,outfilepath,'Karl_Cohab_NAcc_Power');


figure; pwelch(chan5,[],[],[],SampleRate)

title('Karl Cohabitation BLA power spectrum')

savefigure(gcf,outfilepath,'Karl_Cohab_BLA_Power');

%% plot all signals in one figure
figure;
plot(chan3(1e6:1.1e6))
hold on
plot(chan4(1e6:1.1e6),'r')
plot(chan5(1e6:1.1e6),'k')

title('Karl Cohab All 3 Channels mPFC Nacc BLA')
legend('mPFC','NAcc','BLA')
savefigure(gcf,outfilepath,'Karl_Cohab_AllChannels');

%% plot the aligned 
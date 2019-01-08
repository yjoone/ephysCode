%% generate figures for Miranda. jK 112918
% chan3 - mPFC, chan5 - NAcc, chan6 - BLA
datarange = [1e6:5.4e6];
samplingRate = 200;
outfilepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Miranda\Analysis';
subjectID = 'Miranda';


load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Miranda\Habituation2_and_Cohab_Miranda_112218.mat')

%% mPFC

outfilename = [subjectID '_Cohab_mPFC_powerspectra'];
curData = chan3(datarange);

figure; 
subplot(2,1,1)
plot(curData)
subplot(2,1,2)
xlabel('Samples')
title(['Miranda Cohab mPFC 112218']);
pwelch(curData,[],[],[],samplingRate)

savefigure(gcf,outfilepath,outfilename)

%% NAcc

outfilename = [subjectID '_Cohab_NAcc_powerspectra'];
curData = chan5(datarange);

figure; 
subplot(2,1,1)
plot(curData)
subplot(2,1,2)
xlabel('Samples')
title(['Miranda Cohab NAcc 112218']);
pwelch(curData,[],[],[],samplingRate)

savefigure(gcf,outfilepath,outfilename)

%% BLA

outfilename = [subjectID '_Cohab_BLA_powerspectra'];
curData = chan6(datarange);

figure; 
subplot(2,1,1)
plot(curData)
subplot(2,1,2)
xlabel('Samples')
title(['Miranda Cohab BLA 112218']);
pwelch(curData,[],[],[],samplingRate)

savefigure(gcf,outfilepath,outfilename)
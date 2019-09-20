clear all
close all

outpath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\PFCPowerChangeAnalysis_BaselineToCohab'
expDatabasefile = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\ExperimentSummary_091619.xlsx';
savefigures = 'on'
recordingSite = 'mPFC';
animalIDcol = 1;
datafoldercol = 2;
rawfilenamecol = 3;
experimentcol = 4;
recsitecol = 5;
chancol = 6;
activeperiodstartcol = 7;
activeperiodstopcol = 8;

% import excel data
[num,txt,raw] = xlsread(expDatabasefile,'RecordingData');

[r,c] = size(raw);
fcount = 1;

for i = 2:r
    indrecfile = raw(i,:);
    
    % check if the recording site is used for analysis
    if strcmpi(recordingSite,indrecfile(recsitecol))
        
        % unload active period info
        animalID = indrecfile{animalIDcol};
        experiment = indrecfile{experimentcol};
        activeperiodstart = indrecfile{activeperiodstartcol};
        activeperiodstop = indrecfile{activeperiodstopcol};
        fullfilename = fullfile(indrecfile(datafoldercol),indrecfile(rawfilenamecol));
        load(fullfilename{1})
        datachan = ['chan' num2str(indrecfile{chancol})];
        eval(['data = ' datachan ';'])
        activedata = data(activeperiodstart:activeperiodstop);
        
        % identify periods without clipping
        noclipi = activedata > 0 & activedata < 255;
        M = movmean(noclipi,round(samplerate));
        Mi = find(M == 1);
        micount = 1;
        pxxall = [];
        f = [];
        previousi = 1;
        if ~isempty(Mi)
            for j = 1:length(Mi)
                curi = Mi(j);
                if curi > previousi+199
                    if curi > 100 && curi < (length(activedata)-99)
                        activedata_temp = activedata(curi-100:curi+99);
                        [pxx_temp,f] = pwelch(activedata_temp,200,0,200,samplerate);
                        pxxall(micount,:) = pxx_temp;
                        % fall(j,:) = f_temp;
                        micount = micount+1;
                    end
                end
                % store curi to skip over the period that has already been
                % analyzed. This is done to skip the overlap.
                previousi = curi;
            end
        end
        % save the PSD for no clipping periods
        poweroutfilename = [animalID '_' experiment '_NoClippingPSD'];
        save(fullfile(outpath,poweroutfilename),'pxxall','f');
        
        pxx = mean(pxxall);

%           This was commented out because it included clipping periods. Above for loop will replace this        
%         % run pwelch 
%         [pxx_temp,f_temp] = pwelch(activedata,500,250,1000,samplerate);
%         pxxall{fcount} = pxx_temp;
%         fall{fcount} = f_temp;
        
        % get average power for frequency bands
        thetamean(fcount) = mean(pxx(f >= 4 & f <12));
        betamean(fcount) = mean(pxx(f >= 12 & f <30));
        lgammamean(fcount) = mean(pxx(f >= 30 & f <58));
        hgammamean(fcount) = mean(pxx(f >= 62 & f <100));
        
        % plot power spectrum
        if strcmp(savefigures,'on')
            if ~isnan(pxx)
                % figure; pwelch(activedata,500,250,1000,samplerate)
                figure; plot(f,10*log10(pxx))
                xlabel('Frequency (Hz)')
                ylabel('Power/frequncy (dB/Hz)')
                title([animalID experiment recordingSite])
                outfilename = [animalID '_' experiment '_' recordingSite '_Pwelch'];
                savefig(fullfile(outpath,outfilename))
                print(fullfile(outpath,outfilename),'-dpng')
                close(gcf)
            end
        end
        fcount = fcount+1;
        clear pxxall;
    end
end

%% run a quick change in power analysis here
habit1theta = thetamean(1:3:end);
habit2theta = thetamean(2:3:end);
cohabtheta = thetamean(3:3:end);
habit1ToCohabtheta = habit1theta - cohabtheta;
habit2ToCohabtheta = habit2theta - cohabtheta;


habit1beta = betamean(1:3:end);
habit2beta = betamean(2:3:end);
cohabbeta = betamean(3:3:end);
habit1ToCohabbeta = habit1beta - cohabbeta;
habit2ToCohabbeta = habit2beta - cohabbeta;


habit1lgamma = lgammamean(1:3:end);
habit2lgamma = lgammamean(2:3:end);
cohablgamma = lgammamean(3:3:end);
habit1ToCohablgamma = habit1lgamma - cohablgamma;
habit2ToCohablgamma = habit2lgamma - cohablgamma;


habit1hgamma = hgammamean(1:3:end);
habit2hgamma = hgammamean(2:3:end);
cohabhgamma = hgammamean(3:3:end);
habit1ToCohabhgamma = habit1hgamma - cohabhgamma;
habit2ToCohabhgamma = habit2hgamma - cohabhgamma;

%% plot the figures
%%%%%%%%% important %%%%%%%%%%% based on animal treatment group. put it in
%%%%%%%%% the excel sheet in future.
keyboard
otai = logical([1 0 0 1 1 0 1]);

% theta
OTAdata = habit1ToCohabtheta(otai);
aCSFdata = habit1ToCohabtheta(~otai);
analysisname = 'Habituation1 to Cohab PFC Theta 4 to 12 Hz Power change';
plotPowerChangeData(OTAdata,aCSFdata,analysisname,outpath)

OTAdata = habit2ToCohabtheta(otai);
aCSFdata = habit2ToCohabtheta(~otai);
analysisname = 'Habituation2 to Cohab PFC Theta 4 to 12 Hz  Power change';
plotPowerChangeData(OTAdata,aCSFdata,analysisname,outpath)

% beta
OTAdata = habit1ToCohabbeta(otai);
aCSFdata = habit1ToCohabbeta(~otai);
analysisname = 'Habituation1 to Cohab PFC Beta 12 to 30 Hz Power change';
plotPowerChangeData(OTAdata,aCSFdata,analysisname,outpath)

OTAdata = habit2ToCohabbeta(otai);
aCSFdata = habit2ToCohabbeta(~otai);
analysisname = 'Habituation2 to Cohab PFC Beta 12 to 30 Hz Power change';
plotPowerChangeData(OTAdata,aCSFdata,analysisname,outpath)

% low gamma
OTAdata = habit1ToCohablgamma(otai);
aCSFdata = habit1ToCohablgamma(~otai);
analysisname = 'Habituation1 to Cohab PFC low gamma 30 to 58 Hz Power change';
plotPowerChangeData(OTAdata,aCSFdata,analysisname,outpath)

OTAdata = habit2ToCohablgamma(otai);
aCSFdata = habit2ToCohablgamma(~otai);
analysisname = 'Habituation2 to Cohab PFC low gamma 30 to 58 Hz Power change';
plotPowerChangeData(OTAdata,aCSFdata,analysisname,outpath)

% high gamma
OTAdata = habit1ToCohabhgamma(otai);
aCSFdata = habit1ToCohabhgamma(~otai);
analysisname = 'Habituation1 to Cohab PFC high gamma 62 to 90 Hz Power change';
plotPowerChangeData(OTAdata,aCSFdata,analysisname,outpath)

OTAdata = habit2ToCohabhgamma(otai);
aCSFdata = habit2ToCohabhgamma(~otai);
analysisname = 'Habituation2 to Cohab PFC high gamma 62 to 90 Hz Power change';
plotPowerChangeData(OTAdata,aCSFdata,analysisname,outpath)
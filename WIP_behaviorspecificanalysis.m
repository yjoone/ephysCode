% script to organize the data for behavior specific analysis

% potential input variables
recordingSite = 'mPFC';
experimentID = 'Cohab';
treatment = 'OTA';

%% identify base info
expDatabasefile = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\ExperimentSummary_091619.xlsx';
savefigures = 'on'
% recordingSite = 'mPFC';
animalIDcol = 1;
datafoldercol = 2;
rawfilenamecol = 3;
experimentcol = 4;
recsitecol = 5;
chancol = 6;
activeperiodstartcol = 7;
activeperiodstopcol = 8;
treatmentcol = 9;

% import excel data
[num,txt,raw] = xlsread(expDatabasefile,'RecordingData');

[r,c] = size(raw);
fcount = 1;

% load the data

for i = 2:r
    indrecfile = raw(i,:);
    
    % check if the recording site is used for analysis
    if strcmpi(recordingSite,indrecfile(recsitecol)) && strcmpi(experimentID,indrecfile(experimentcol)) ...
            && strcmpi(treatment,indrecfile(treatmentcol))
        
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
       
% This is where all the data organization takes place before runModBehavior
% 
dam = 
[modStruct,rasterWindowTimesSamplesStruct,flow,fhigh] = ...
    runModBehavior(dam,startLastRangeSamples,chanNameCellPhaseFreq,...
    chanNameCellAmpFreq,dataAcq,varargin)
        
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
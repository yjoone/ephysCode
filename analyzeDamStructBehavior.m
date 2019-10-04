function [pxxall,f] = analyzeDamStructBehavior(damStruct,behaviorID,plotTF)

% this function takes in the fully loaded damStruct data, and based on
% specified behaviorID, get the power spectrum density, and plot the
% results.

% THIS FUNCTION IS WRITTEN FOR COHAB PFC ANALYSIS. CHANGE THE DAMSTRUCT INPUT TO
% OTHER BRAIN AREAS IF YOU WISH TO LOOK AT OTHER REGIONS. CURRENTLY IT'S
% ONLY FOR FIGURE TITLE THAT IS HARDCODED IN.
if nargin <3
    plotTF = 'off';
end

outpath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\BehaviorSpecificPFCPowerAnalysis';

%% unload the data from damStruct
animalID = damStruct.animal;
experiment = 'Cohab';
recordingSite = 'PFC';
samplerate = damStruct.param.samplerate;
signal = damStruct.trials.signal;
behavindices = damStruct.trials.behavindices.(behaviorID);

%% get the behavior specific signal

[r,~] = size(behavindices);
micount = 1;
pxxall = [];
for i = 1:r
    activedata_temp = signal(behavindices(i,1):behavindices(i,2));
    [pxx_temp,f] = pwelch(activedata_temp,100,0,100,samplerate);
    pxxall(micount,:) = pxx_temp;
    micount = micount+1;
end


if strcmp(plotTF,'on')
    %% plot power spectrum line by line
    linecolorvar = linspace(0,0.7,r);
    figure;
    hold on
    for j = 1:r
        % unload each epoch of behavior
        pxx = pxxall(j,:);
        if ~isnan(pxx)
            % figure; pwelch(activedata,500,250,1000,samplerate)
            plot(f,10*log10(pxx),'color',[linecolorvar(j) linecolorvar(j) linecolorvar(j)])
            xlabel('Frequency (Hz)')
            ylabel('Power/frequncy (dB/Hz)')
            title([animalID experiment recordingSite ' Each behavior epoch ' behaviorID])
            outfilename = [animalID '_' experiment '_' recordingSite '_Pwelch_EachLine_' behaviorID];
            savefig(fullfile(outpath,outfilename))
            print(fullfile(outpath,outfilename),'-dpng')
            
        end
    end
    close(gcf)
    %% plot the average power spectrum
    figure;
    pxxmean = mean(pxxall);
    plot(f,10*log10(pxxmean))
    xlabel('Frequency (Hz)')
    ylabel('Power/frequncy (dB/Hz)')
    title([animalID experiment recordingSite ' mean behavior' behaviorID])
    outfilename = [animalID '_' experiment '_' recordingSite '_Pwelch_all_' behaviorID];
    savefig(fullfile(outpath,outfilename))
    print(fullfile(outpath,outfilename),'-dpng')
    close(gcf)
end
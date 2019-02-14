function modStruct = plotModStruct(modStruct,fhigh,flow,animalID,outfilepath,varargin)

% This function takes in the modStruct output and plots individual MI.

clims = [0 5e-3];
climsnet = [-3e-3 3e-3];
assign(varargin{:})

mfields = fields(modStruct);

% %% plot each MI
% for i = 1:length(mfields)
%     datatempi = 1;
%     nonani = [];
%     regionID = mfields{i};
%     data = modStruct.(mfields{i}).all;
%     
%     [~,~,nepochs] = size(data); % behavior epochs are in 3 dim
%     
%     for j = 1:nepochs
%         if ~isnan(data(:,:,j)) %skip over NaNs
%             figure('visible','off')
%             imagesc(fhigh,flow,data(:,:,j));
%             set(gca,'clim',clims);
%             colorbar;
%             xlabel('amplitude Frequency (Hz)')
%             ylabel('phase Frequency (Hz)')
%             title(['Modulation Index of ' animalID ' for ' regionID ' ' num2str(j)])
%             outfilename = ['ModulationIndex_' animalID '_' regionID '_' num2str(j)];
%             savefigure(gcf,outfilepath,outfilename)
%             close(gcf)
%             datatemp(:,:,datatempi) = data(:,:,j);
%             datatempi = datatempi+1;
%             nonani = [nonani; j];
%         end
%     end
%     
%     % plot the mean values of MI
%     datamean = mean(datatemp,3);
%     figure('visible','off')
%     imagesc(fhigh,flow,datamean);
%     set(gca,'clim',clims);
%     colorbar;
%     xlabel('amplitude Frequency (Hz)')
%     ylabel('phase Frequency (Hz)')
%     title(['Average Modulation Index of ' animalID ' for ' regionID])
%     outfilename = ['AverageModulationIndex_' animalID '_' regionID];
%     savefigure(gcf,outfilepath,outfilename)
%     close(gcf)
% 
%     % store the non NaN and average data to modStruct for future use
%     modStruct.(mfields{i}).nonNaN = datatemp;
%     modStruct.(mfields{i}).nonNaNmean = datamean;
%     modStruct.(mfields{i}).nonani = nonani;
%     
% end

    
%% plot the subtracted value and average it from modStruct
for i = 1:length(mfields)
    fieldname = mfields{i};
    fieldnames = strsplit(fieldname,'to');
    fieldnamereverse = [fieldnames{2} 'to' fieldnames{1}];
    regionID = [fieldname 'Minus' fieldnamereverse];
    
    % get each of the MI data
    data = modStruct.(mfields{i}).all;
    datanonani = modStruct.(mfields{i}).nonani;
    datareverse = modStruct.(fieldnamereverse).all;
    datareversenonani = modStruct.(fieldnamereverse).nonani;

    netdata = data - datareverse;
    nanimatch = ismember(datanonani,datareversenonani);
    
    netdatamean = mean(netdata(:,:,datanonani(nanimatch)),3);
    
    figure('visible','off')
    imagesc(fhigh,flow,netdatamean);
    set(gca,'clim',climsnet);
    colorbar;
    xlabel('amplitude Frequency (Hz)')
    ylabel('phase Frequency (Hz)')
    title(['Average Net Modulation Index of ' animalID ' for ' regionID])
    outfilename = ['AverageNetModulationIndex_' animalID '_' regionID];
    savefigure(gcf,outfilepath,outfilename)
    close(gcf)
end
    
    
    
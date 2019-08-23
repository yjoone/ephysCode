function plotAnalyzedModStructNoBehav(modStruct,outfilepath)

% this function takes in the output modStruct from analyzedModStructNoBehav
% and plots relevant figures.

%% hard coded figure parameters
climsnet = [-1e-3 2e-3];

%% plot mean net MI for each net fields

fieldnames = fields(modStruct);

for i = 1:length(fieldnames)
    fieldnametemp = fieldnames{i};
    if strcmp(fieldnametemp(1:3),'net') % if the field is the net field...
        figure('visible','off')
        imagesc(modStruct.param.fhigh,modStruct.param.flow,modStruct.(fieldnametemp).mean);
        set(gca,'clim',climsnet);
        colorbar;
        colormap jet
        xlabel('amplitude Frequency (Hz)')
        ylabel('phase Frequency (Hz)')
        title(['Average Net Modulation Index of ' modStruct.animalID ' for ' fieldnametemp])
        outfilename = ['AverageNetModulationIndex_' modStruct.animalID '_' fieldnametemp];
        savefigure(gcf,outfilepath,outfilename)
        close(gcf)
    end
end


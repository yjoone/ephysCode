function plotCoherogramStructsubroutine_power(data,f,t,animalID,behavior,clim,climpower,varargin)

% subroutine of plotCoherogramStruct but for multitaper power.
% Plots each figure based on input
assign(varargin{:})

figure('visible','off');
imagesc(f,t,data)
colorbar
set(gca,'clim',climpower)
colormap jet
title(['Multitaper Power plot ' behavior ' ' channame ' '  animalID])
xlabel('Frequency (Hz)')
ylabel('Time (ms)')

if exist('trials','var')
    ylabel('Behavior epochs')
end
% save figures
outfilepath = cd;
outfilename = ['MultitaperPowerplot_' behavior '_' channame  '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)

%% plot the line graph
figure('visible','off');
plotGradient(data,f)
set(gca,'ylim',climpower)
title(['Multitaper Line Power plot ' behavior ' ' channame ' '  animalID])
xlabel('Frequency (Hz)')
ylabel('Time (ms)')

% save figures
outfilepath = cd;
outfilename = ['MultitaperLinePowerplot_' behavior '_' channame  '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)

%% plot the average line graph
figure('visible','off');
plot(f,mean(data))
set(gca,'ylim',climpower);
title(['Multitaper Line Average Power plot ' behavior ' ' channame ' '  animalID])
xlabel('Frequency (Hz)')
ylabel('Time (ms)')

% save figures
outfilepath = cd;
outfilename = ['MultitaperLineAveragePowerplot_' behavior '_' channame  '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)

%% plot the average line graph
figure('visible','off');

% compute the standard error to add
stdev = std(data);
sz = size(data);
stderr = stdev./sqrt(sz(1));
plot(f,mean(data))
shadedErrorBar(f,mean(data),stderr)
set(gca,'ylim',climpower);
title(['Multitaper Line Average Power plot ' behavior ' ' channame ' '  animalID])
xlabel('Frequency (Hz)')
ylabel('Time (ms)')

% save figures
outfilepath = cd;
outfilename = ['MultitaperLineAveragePowerShadedplot_' behavior '_' channame  '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)
end
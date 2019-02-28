function plotCoherogramStructsubroutine(data,f,t,animalID,behavior,clim,climpower,varargin)

% subroutine of plotCoherogramStruct. Plots each figure based on input
assign(varargin{:})

figure('visible','off');
imagesc(f,t,data)
colorbar
set(gca,'clim',clim)
colormap jet
title(['Coherence plot ' behavior ' ' chan1name ' and '...
    chan2name ' '  animalID ])
xlabel('Frequency (Hz)')
ylabel('Time (ms)')

% save figures
outfilepath = cd;
outfilename = ['CoherencePlot_' behavior '_' chan1name  '_and_'...
    chan2name '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)

%% plot the line graph
figure('visible','off');
plotGradient(data,f)
set(gca,'ylim',clim)
title(['Coherence line plot ' behavior ' ' chan1name ' and '...
    chan2name ' '  animalID ])
xlabel('Frequency (Hz)')
ylabel('Coherence value')


% save figures
outfilepath = cd;
outfilename = ['CoherenceLinePlot_' behavior '_' chan1name  '_and_'...
    chan2name '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)


%% plot the average line graph
figure('visible','off');
plot(f,mean(data));
set(gca,'ylim',clim)
title(['Coherence line average plot ' behavior ' ' chan1name ' and '...
    chan2name ' '  animalID ])
xlabel('Frequency (Hz)')
ylabel('Coherence value')

% save figures
outfilepath = cd;
outfilename = ['CoherenceLineAveragePlot_' behavior '_' chan1name  '_and_'...
    chan2name '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)

%% plot the average line graph with error bars
figure('visible','off');
% compute the standard error to add
stdev = std(data);
sz = size(data);
stderr = stdev./sqrt(sz(1));
plot(f,mean(data));
shadedErrorBar(f,mean(data),stderr)
set(gca,'ylim',clim)
title(['Coherence line average plot ' behavior ' ' chan1name ' and '...
    chan2name ' '  animalID ])
xlabel('Frequency (Hz)')
ylabel('Coherence value')

% save figures
outfilepath = cd;
outfilename = ['CoherenceLineAverageShadedPlot_' behavior '_' chan1name  '_and_'...
    chan2name '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)

end
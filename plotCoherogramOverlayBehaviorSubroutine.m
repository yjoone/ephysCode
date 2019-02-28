function plotCoherogramOverlayBehaviorSubroutine(coherogramStruct,animalID,clim,varargin)

% subroutine of plotCoherogramStruct. Plots each figure based on input
assign(varargin{:})


%% unload the data
behfields = fields(coherogramStruct);
nfield = length(behfields);
for i = 1:nfield
    eval([behfields{i} 'data = coherogramStruct.(behfields{i}).C;'])
end
f = coherogramStruct.mountingMale.f;

%% compute the errors
sz = size(huddlingMaledata);
hstd = std(huddlingMaledata);
hstderr = hstd./sqrt(sz(1));
mstd = std(mountingMaledata);
mstderr = mstd./sqrt(sz(1));
sstd = std(selfgroomingMaledata);
sstderr = sstd./sqrt(sz(1));


%% plot the average line graph with error bars
fh = figure('visible','off');
% compute the standard error to add
hold on
ph1 = shadedErrorBar(f,mean(huddlingMaledata),hstderr,'lineprops','r');
ph2 = shadedErrorBar(f,mean(mountingMaledata),hstderr,'lineprops','m');
ph3 = shadedErrorBar(f,mean(selfgroomingMaledata),hstderr,'lineprops','g');

set(gca,'ylim',clim)
title(['Coherence line average plot all behavior ' chan1name ' and '...
    chan2name ' '  animalID ])
xlabel('Frequency (Hz)')
ylabel('Coherence value')
legend([ph1.mainLine ph2.mainLine ph3.mainLine],behfields)
set(gca,'xtick',[0:10:100])
% save figures
outfilepath = cd;
outfilename = ['AllBehaviorCoherenceLineAverageShadedPlot_' chan1name  '_and_'...
    chan2name '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)

% %% plot the line graph
% figure('visible','off');
% plotGradient(data,f)
% set(gca,'ylim',clim)
% title(['Coherence line plot ' behavior ' ' chan1name ' and '...
%     chan2name ' '  animalID ])
% xlabel('Frequency (Hz)')
% ylabel('Coherence value')
% 
% 
% % save figures
% outfilepath = cd;
% outfilename = ['CoherenceLinePlot_' behavior '_' chan1name  '_and_'...
%     chan2name '_' animalID];
% savefigure(gcf,outfilepath,outfilename)
% close(gcf)
% 
% 
% %% plot the average line graph
% figure('visible','off');
% plot(f,mean(data));
% set(gca,'ylim',clim)
% title(['Coherence line average plot ' behavior ' ' chan1name ' and '...
%     chan2name ' '  animalID ])
% xlabel('Frequency (Hz)')
% ylabel('Coherence value')
% 
% % save figures
% outfilepath = cd;
% outfilename = ['CoherenceLineAveragePlot_' behavior '_' chan1name  '_and_'...
%     chan2name '_' animalID];
% savefigure(gcf,outfilepath,outfilename)
% close(gcf)


end
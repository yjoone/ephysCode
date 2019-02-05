function plotSpectrogram(damStruct,animalID,varargin)

% x_ds is downsampled data assuming 48 fold downsample
% behaviorstruct is output from compileBehavior
% animalID is the data name

% updated on 011018 JK to run the data from neurologger. Only change was
% the sampling rate.


%%%%%% HARD CODED VALUES%%%%%%%%%%%%%%%
% fs = 24414/48;
fs = 199.8049;
window = 512;
overlap = 256;
saveFig = 'on';
clim = [5 30]; 
% outfilepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\spectogramAnalysis';
outfilepath = cd;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(varargin{:})
x_ds = damStruct.trials.signal;

[spec,f,t] = spectrogram(x_ds,window,overlap,[],fs);

spec_dB = 10*log10(abs(shiftdim(spec)));
fh = figure;
h = imagesc(t, f, spec_dB);

axis('xy');
caxis(clim)
% caxis(quantile(spec_dB(:),[.02,.98]));
set(gca,'ylim',[0 100]);
colormap(bone);
xlabel('Time (s)');
ylabel('Frequency (Hz)');

cb = colorbar;
ylabel(cb, 'Power spectral density (dB/Hz)');
hold on;

%% overlay the behavior times
overlayBehavior(damStruct,behavior)
% commented below out for pre-behavior scoring analysis

% beh = unique(behaviorStruct.Behaviors);
% 
% for i = 1:length(beh)
%     switch beh(i)
%         case 0
%             ii = behaviorStruct.Behaviors == beh(i);
%             plot(behaviorStruct.Time_s(ii),80,'*b','markersize',15);
%         case 1
%             ii = behaviorStruct.Behaviors == beh(i);
%             plot(behaviorStruct.Time_s(ii),75,'or','markersize',5);
%         case 2
%             ii = behaviorStruct.Behaviors == beh(i);
%             plot(behaviorStruct.Time_s(ii),70,'og','markersize',5);
%     end
% end

if strcmp(saveFig,'on')
    fileName_fig = [animalID '_spectrogram.fig'];
    fileName_png = [animalID '_spectrogram.png'];
    savefig(fh,fullfile(outfilepath,fileName_fig));
    print(gcf,fullfile(outfilepath,fileName_png),'-dpng');
end

close(fh);

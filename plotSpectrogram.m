function plotSpectrogram(x_ds,behaviorStruct,animalID,filePath,saveFig)

% x_ds is downsampled data assuming 48 fold downsample
% behaviorstruct is output from compileBehavior
% animalID is the data name

if nargin < 4
    filePath = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\spectogramAnalysis';
    saveFig = 'on';
end

%%%%%% HARD CODED SAMPLING RATE %%%%%%%
fs = 24414/48;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

window = 1000;
overlap = 500;


[spec,f,t] = spectrogram(x_ds,window,overlap,[],fs);

spec_dB = 10*log10(abs(shiftdim(spec)));
fh = figure;
h = imagesc(t, f, spec_dB);

axis('xy');
caxis(quantile(spec_dB(:),[.02,.98]));
set(gca,'ylim',[0 100]);
colormap(bone);
xlabel('Time (s)');
ylabel('Frequency (Hz)');

cb = colorbar;
ylabel(cb, 'Power spectral density (dB/Hz)');
hold on;

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
    savefig(fh,fullfile(filePath,fileName_fig));
    print(gcf,fullfile(filePath,fileName_png),'-dpng');
end

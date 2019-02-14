function plotBehSpectrogram(damStruct,animalID,behavIDname,varargin)


% 
fs = 199.8049;
window = 128;
overlap = 64;
saveFig = 'on';
clim = [5 30]; 
subplotrawtrace = 'on';
outfilepath = cd;

assign(varargin{:})
%% plot spectrogram for each behavior epochs if exists
signal = damStruct.trials.signal;
behdata = damStruct.trials.behavindices.(behavIDname); % nx2

%% set up the loop to plot each epoch
[r,c] = size(behdata);

for i = 1:r
    behtimestart = behdata(i,1);
    behtimestop = behdata(i,2);
    behsignal = signal(behtimestart:behtimestop);
    
    
    [spec,f,t] = spectrogram(behsignal,window,overlap,[],fs);
    
    spec_dB = 10*log10(abs(shiftdim(spec)));
    fh = figure('visible','off');
    
    if strcmpi(subplotrawtrace,'on') % create subplot if plotting raw trace
        subplot(2,1,1);
    end
    
    h = imagesc(t, f, spec_dB);
    
    axis('xy');
    caxis(clim)
    % caxis(quantile(spec_dB(:),[.02,.98]));
    set(gca,'ylim',[0 100]);
    colormap(bone);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    
    title(['Spectrogram ' animalID ' ' behavIDname  ' ' ...
        num2str(i)]);
    
    cb = colorbar;
    ylabel(cb, 'Power spectral density (dB/Hz)');
    
    if strcmpi(subplotrawtrace,'on')
        subplot(2,1,2)
        plot(behsignal)
        ylabel('NL unit')
        xlabel('Samples')
        title(['Spectrogram and Raw trace ' animalID ' ' behavIDname ' ' ...
            num2str(i)])

        outfilename = ['SpectrogramAndRawTrace_' animalID '_' behavIDname '_' ...
            num2str(i)];
    else
    
        outfilename = ['Spectrogram ' animalID '_' behavIDname '_' ...
            num2str(i)];
    end
    
    savefigure(gcf,outfilepath,outfilename);
    close(fh);
end

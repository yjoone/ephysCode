function plotBehPwelch(damStruct,animalID,varargin)
% This function plots pwelch spectrum of each behavior epochs.

samplerate = 199.804878;
ylims = [-1.5 2.5];

assign(varargin{:})

behaviors = fields(damStruct.trials.behavindices);

for nb = 1:numel(behaviors)
    behname = behaviors{nb};
    behtime = damStruct.trials.behavindices.(behaviors{nb});
    signal = damStruct.trials.signal;
    
    % get the number of epochs
    [nepochs,~] = size(behtime);
    
    for i = 1:nepochs
        % data = signal(behtime(i,1):behtime(i,2));
        data = signal(behtime(i,1):(behtime(i,1)+200));
        figure('visible','off');
        [pxx(i,:),f(i,:)] = pwelch(data,[],[],[],samplerate);
        plot(f(i,:),log10(pxx(i,:)));
        set(gca,'ylim',ylims)
        ylabel('Log10 power')
        xlabel('Frequency (Hz)')
        title(['Pwelch plot ' behname ' '  animalID ' ' num2str(i)])
        
        
        % save figures
        outfilepath = cd;
        outfilename = ['PwelchPlot' behname '_' animalID ' ' num2str(i)];
        savefigure(gcf,outfilepath,outfilename)
        close(gcf)
    end
    %% plot the gradient graph
    
        figure('visible','off');
        plotGradient(log10(pxx),f(1,:))
        set(gca,'ylim',ylims)
        ylabel('Log10 power')
        xlabel('Frequency (Hz)')
        title(['Pwelch Gradient plot ' behname ' '  animalID])
        
        
        % save figures
        outfilepath = cd;
        outfilename = ['PwelchGradientPlot' behname '_' animalID];
        savefigure(gcf,outfilepath,outfilename)
        close(gcf)
    %% plot average power
        
        figure('visible','off');
        mpxx = mean(pxx);
        mf = mean(f);
        plot(mf,log10(mpxx))
        set(gca,'ylim',ylims)
        ylabel('Log10 power')
        xlabel('Frequency (Hz)')
        title(['Average Pwelch Gradient plot ' behname ' '  animalID])
        
        
        % save figures
        outfilepath = cd;
        outfilename = ['Average PwelchPlot' behname '_' animalID];
        savefigure(gcf,outfilepath,outfilename)
        close(gcf)
end


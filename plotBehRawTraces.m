function plotBehRawTraces(damStruct,animalID,behavIDname,outfilepath,varargin)

% this function takes in the fully organized damStruct, from
% SamplePipeline, and plots the raw traces for each behavior epochs of the
% behavIDname


%% assign variables and defaults
outfilepath = cd;
padding = 1.5; %seconds
samplerate = 200; %neurologger sampling rate

assign(varargin{:})
%% unload the data
signal = damStruct.trials.signal;
behdata = damStruct.trials.behavindices.(behavIDname); % nx2

%% set up the loop to plot each epoch
[r,c] = size(behdata);
padding_samples = padding*samplerate;

for i = 1:r
    behtimestart = behdata(i,1);
    behtimestop = behdata(i,2);
    behsignal{i} = signal((behtimestart-padding_samples)...
        :(behtimestop+padding_samples));
    line1{i} = padding_samples;
    line2{i} = (behtimestop - behtimestart)+padding_samples;
    
    % plot the figure
    fh = figure('visible','off');
    plot(behsignal{i})
    hold on;
    line([line1{i} line1{i}],get(gca,'ylim'))
    line([line2{i} line2{i}],get(gca,'ylim'))
    ylabel('NL unit')
    xlabel('Samples')
    title(['Raw trace ' animalID ' ' behavIDname ' ' ...
        num2str(i)])
    
    outfilename = ['Rawtrace_' animalID '_' behavIDname '_' ...
        num2str(i)];
    
    savefigure(fh,outfilepath,outfilename);
    close(fh);
end

%% plot the figures in subplot for easy visualization

for j = 1:floor(r/9)
    % plot the figure
    fh = figure('visible','off');
    ylabel('NL unit')
    xlabel('Samples')
    title(['Raw trace ' animalID ' ' behavIDname ' ' ...
        num2str(j)])
    for js = 1:9
        behindex = (j-1)*9 + js;
        subplot(3,3,js)
        plot(behsignal{behindex})
        hold on;
        line([line1{behindex} line1{behindex}],get(gca,'ylim'))
        line([line2{behindex} line2{behindex}],get(gca,'ylim'))
    end
    outfilename = ['Rawtrace_subplots_' animalID '_' behavIDname '_' ...
        num2str(j)];
    
    savefigure(fh,outfilepath,outfilename);
    close(fh);
end

rr = rem(r,9);

% plot the figure
fh = figure('visible','off');
ylabel('NL unit')
xlabel('Samples')
title(['Raw trace ' animalID ' ' behavIDname ' ' ...
    num2str(j)])
for js = 1:rr
    behindex = (j-1)*9 + js;
    subplot(3,3,js)
    plot(behsignal{behindex})
    hold on;
    line([line1{behindex} line1{behindex}],get(gca,'ylim'))
    line([line2{behindex} line2{behindex}],get(gca,'ylim'))
end
outfilename = ['Rawtrace_subplots_' animalID '_' behavIDname '_' ...
    num2str(j+1)];

savefigure(fh,outfilepath,outfilename);
close(fh);
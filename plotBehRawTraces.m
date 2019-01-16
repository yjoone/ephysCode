function plotBehRawTraces(damStruct,animalID,behavIDname,outfilepath)

% this function takes in the fully organized damStruct, from
% SamplePipeline, and plots the raw traces for each behavior epochs of the
% behavIDname

%% unload the data
signal = damStruct.trials.signal;
behdata = damStruct.trials.behavindices.(behavIDname); % nx2 

%% set up the loop to plot each epoch
[r,c] = size(behdata);

for i = 1:r
    behtimestart = behdata(i,1);
    behtimestop = behdata(i,2);
    behsignal = signal(behtimestart:behtimestop);
    
    % plot the figure
    fh = figure('visible','off')
    plot(behsignal)
    ylabel('NL unit')
    xlabel('Samples')
    title(['Raw trace ' animalID ' ' behavIDname ' ' ...
        num2str(i)])
    
    outfilename = ['Rawtrace_' animalID '_' behavIDname '_' ...
        num2str(i)];
    
    savefigure(fh,outfilepath,outfilename);
    close(fh);
end

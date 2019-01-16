function plotBehRawTraces(damStruct,animalID,behavIDname,outfilepath)

% this function takes in the fully organized damStruct, from
% SamplePipeline, and plots the raw traces for each behavior epochs of the
% behavIDname

%% unload the data
signal = damStruct.trials.signal;
behdata = damNeil_NAcc.trials.behavindices.(behavIDname); % nx2 

%% set up the loop to plot each epoch
[r,c] = size(behdata);

for i = 1:r
    behtimestart = behdata(r,1);
    behtimestop = behdata(r,2);
    behsignal = signal(behtimestart:behtimestop);
    
    % plot the figure
    figure('visible','off')
    plot(behsignal)
    ylabel('NL unit')
    xlabel('Samples')
    title(['Raw trace ' animalID ' ' behavIDname ' ' ...
        num2str(i)])
    
    outfilename = ['Rawtrace_' animalID '_' behavIDname '_' ...
        num2str(i)];
    
    savefigure(gcf,outfilepath,outfilename);
end

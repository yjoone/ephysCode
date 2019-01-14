function plotCoherogramStruct(coherogramStruct,animalID,chan1name,chan2name,varargin)

% this function take in the coherogramStruct, output from SamplePipeline
% and plots individual behavior epochs or overall average depending on
% coherogramStruct.


climc = [0 2];
climp = [-15 30];
assign(varargin{:})

%% unload the data
behfields = fields(coherogramStruct);
nfield = length(behfields);

%% check whether the coherogramStruct size
% This is done to check if the struct was created with average or not
tempData = coherogramStruct.(behfields{1}).C;
tempDatadim = size(tempData);
if length(tempDatadim) > 2
    noaverage = 0;
    nepochs = tempDatadim(3);
else
    noaverage = 1;
end

% repeat for each behavior (per field)
for i = 1:nfield
    coherogramData = coherogramStruct.(behfields{i}).C;
    mtpowerData1 = coherogramStruct.(behfields{i}).S1;
    mtpowerData2 = coherogramStruct.(behfields{i}).S2;
    f = coherogramStruct.(behfields{i}).f;
    t = coherogramStruct.(behfields{i}).t;
    
    switch noaverage
        case 1
            % plot coherence average
            plotCoherogramStructsubroutine(coherogramData,f,t,[animalID 'Average'],...
                (behfields{i}),climc,'chan1name',chan1name,'chan2name',chan2name)
            
            % plot multitaper power average
            plotCoherogramStructsubroutine_power(mtpowerData1,f,t,[animalID 'Average'],...
                (behfields{i}),climp,'channame',chan1name)
            
            plotCoherogramStructsubroutine_power(mtpowerData2,f,t,[animalID 'Average'],...
                (behfields{i}),climp,'channame',chan2name)
            
        case 0
            % for this case, run each epoch
            for epochi = 1:nepochs
                
                coherogramData_temp = coherogramStruct.(behfields{i}).C(:,:,epochi);
                mtpowerData1_temp = coherogramStruct.(behfields{i}).S1(:,:,epochi);
                mtpowerData2_temp = coherogramStruct.(behfields{i}).S2(:,:,epochi);
                

                plotCoherogramStructsubroutine(coherogramData_temp,f,t,[animalID ' ' num2str(epochi)],...
                    (behfields{i}),climc,'chan1name',chan1name,'chan2name',chan2name)

                % plot multitaper power average
                plotCoherogramStructsubroutine_power(mtpowerData1_temp,f,t,[animalID ' ' num2str(epochi)],...
                    (behfields{i}),climp,'channame',chan1name)

                plotCoherogramStructsubroutine_power(mtpowerData2_temp,f,t,[animalID ' ' num2str(epochi)],...
                    (behfields{i}),climp,'channame',chan2name)
            end
            
            % plot temporal average
            
            coherogramDatas = squeeze(mean(coherogramData,1))';
            mtpowerData1s = squeeze(mean(mtpowerData1,1))';
            mtpowerData2s = squeeze(mean(mtpowerData2,1))';
            
            
            % plot coherence temporal average
            plotCoherogramStructsubroutine(coherogramDatas,f,t,[animalID 'TemporalAverage'],...
                (behfields{i}),climc,'chan1name',chan1name,'chan2name',chan2name,'trials',1)
            
            % plot multitaper temporal power average
            plotCoherogramStructsubroutine_power(mtpowerData1s,f,t,[animalID 'TemporalAverage'],...
                (behfields{i}),climp,'channame',chan1name,'trials',1)
            
            plotCoherogramStructsubroutine_power(mtpowerData2s,f,t,[animalID 'TemporalAverage'],...
                (behfields{i}),climp,'channame',chan2name,'trials',1)
    end
end
end

function plotCoherogramStructsubroutine(data,f,t,animalID,behavior,clim,varargin)

% subroutine of plotCoherogramStruct. Plots each figure based on input
assign(varargin{:})

figure('visible','off');
imagesc(f,t,data)
colorbar
set(gca,'clim',clim)
title(['Coherence plot ' behavior ' ' chan1name ' and '...
    chan2name ' '  animalID ])
xlabel('Frequency (Hz)')
ylabel('Time (ms)')

if exist('trials','var')
    ylabel('Behavior epochs')
end

% save figures
outfilepath = cd;
outfilename = ['CoherencePlot_' behavior '_' chan1name  '_and_'...
    chan2name '_' animalID];
savefigure(gcf,outfilepath,outfilename)
close(gcf)
end

function plotCoherogramStructsubroutine_power(data,f,t,animalID,behavior,clim,varargin)

% subroutine of plotCoherogramStruct but for multitaper power.
% Plots each figure based on input
assign(varargin{:})

figure('visible','off');
imagesc(f,t,data)
colorbar
set(gca,'clim',clim)
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
end



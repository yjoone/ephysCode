function saveNetMIFigs(modStruct,fhigh,flow,filePath)

% function to save all the MI differences for each time bin as well as
% average
% filePath should be the folder that you wish to store the generated
% figures.
% cd 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\PV20161119\20170307_HabitOdor\20sWindow';

if ~exist(filePath)
    mkdir(filePath);
end

% cd(filePath);

modFields = fields(modStruct);
[r,c,t] = size(modStruct.(modFields{1}).all);

% check input MI so that they're paired correctly.
mod_len = length(modFields);
for i = 1:2:mod_len
    display([modFields(i) ' - ' modFields(i+1)])
end

display('If the above equations are correct, please type dbcont')
% keyboard

% loop thru all the sites
for site_i = 1:2:mod_len
    field1 = modFields(site_i);
    field2 = modFields(site_i+1);
    
    outFilePath = fullfile(filePath,[field1{1} '-' field2{1}]);
    if ~exist(outFilePath)
        mkdir(outFilePath)
    else
        disp('The folder already exist. Do you want to overwrite the images?')
        keyboard
    end
    
    cd(outFilePath);
    
    % loop thru all the time bins
    for t_i = 1:t
        MI_1 = modStruct.(field1{1}).all(:,:,t_i);
        MI_2 = modStruct.(field2{1}).all(:,:,t_i);
        MI_net_temp = MI_1 - MI_2;
        
        MI_net{site_i}(:,:,t_i) = MI_net_temp;
        
        figure('visible','off'); imagesc(flow,fhigh,MI_net_temp',[-5e-3 5e-3]); colorbar; axis xy;
        title(['Net MI for ' field1{1} '-' field2{1} ' All - timebin ' num2str(t_i)]);
        xlabel('Low Frequency (Hz)')
        ylabel('High Frequency (Hz)')
        fileName = ['Net_MI_for_' field1{1} '-' field2{1} '_Timebin' num2str(t_i) '.png'];
        print(gcf,fileName,'-dpng');
        close(gcf)
    end
    
    figure; imagesc(flow,fhigh,mean(MI_net_temp,3)',[-5e-3 5e-3]); colorbar; axis xy;
    fileName = ['Net_MI_for_' field1{1} '-' field2{1} '_All.png'];
    fileName_fig = ['Net_MI_for_' field1{1} '-' field2{1} '_All.fig'];
    
    title(['Net MI for ' field1{1} '-' field2{1} ' All']);
    xlabel('Low Frequency (Hz)')
    ylabel('High Frequency (Hz)')
    print(fileName,'-dpng');
    savefig(gcf,fileName_fig);
    % close(gcf)
    save('MI_net.mat','MI_net','modStruct')
end
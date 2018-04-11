% script to save all the MI differences for each time bin as well as
% average
cd 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\PV20161119\20170307_HabitOdor\20sWindow';

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
    
    % loop thru all the time bins
    for t_i = 1:t
        MI_1 = modStruct.(field1{1}).all(:,:,t_i);
        MI_2 = modStruct.(field2{1}).all(:,:,t_i);
        MI_net_temp = MI_1 - MI_2;
        
        MI_net{site_i}(:,:,t_i) = MI_net_temp;
        
        figure('visible','off'); imagesc(flow,fhigh,MI_net_temp'); colorbar; axis xy;
        fileName = ['Net_MI_for_' field1{1} '-' field2{1} '_Timebin' num2str(t_i) '.png'];
        print(gcf,fileName,'-dpng');
        close(gcf)
    end
    
    figure; imagesc(flow,fhigh,mean(MI_net_temp,3)',[-5e-3 5e-3]); colorbar; axis xy;
    fileName = ['Net_MI_for_' field1{1} '-' field2{1} '_All.eps'];
    fileName_fig = ['Net_MI_for_' field1{1} '-' field2{1} '_All.fig'];
    
    title(['Net MI for ' field1{1} '-' field2{1} ' All']);
    xlabel('Low Frequency (Hz)')
    ylabel('High Frequency (Hz)')
    print(fileName,'-depsc');
    savefig(gcf,fileName_fig);
    close(gcf)
    save('MI_net.mat','MI_net','modStruct')
end
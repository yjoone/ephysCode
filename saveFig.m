function saveFig(cfcdata_temp,cfc_i,flow,fhigh,outFilePath)
        MI_net_temp = cfcdata_temp;
        field1{1} = 'PFC';
        field2{1} = 'NAcc';
        t_i = cfc_i;
        
        figure('visible','off'); imagesc(flow,fhigh,MI_net_temp',[-5e-3 5e-3]); colorbar; axis xy;
        title(['Net MI for ' field1{1} '-' field2{1} ' All - timebin ' num2str(t_i)]);
        xlabel('Low Frequency (Hz)')
        ylabel('High Frequency (Hz)')
        fileName = ['Net_MI_for_' field1{1} '-' field2{1} '_Timebin' num2str(t_i) '.png'];
        print(gcf,fullfile(outFilePath,fileName),'-dpng');
        close(gcf)
end

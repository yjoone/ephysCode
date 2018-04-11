% script to run all the analysis on Alvin

% d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Alvin';
% d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Alex';
% d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Abe'
% d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Albert';

d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Abe'

dd = dir(d);

for i = 3:length(dd)
    % check if it's a folder. 
    if dd(i).isdir
        curdir = fullfile(d,dd(i).name);
        cdd = dir(curdir);
        cd(curdir);
        % load all channels
        for j = 3:length(cdd)
          
            tf = isChanMatlabFile(cdd(j).name);
            if strcmp(cdd(j).name,'CoherenceResults.mat')
                load(fullfile(curdir,cdd(j).name));
            end
        end % end of load all channels
        figure; imagesc(real(coherenceStruct.BLAwithNAcc.all)')
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Abe Cohabitation Coherence BLA NAcc')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_All.fig');
        print(gcf,'Coherence_BLA_NACC_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.BLAwithNAcc.all(:,7)),500));
        title('Abe Cohabitation Coherence BLA NAcc 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_10Hz.fig');
        print(gcf,'Coherence_BLA_NACC_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.BLAwithNAcc.all(:,6)),500));
        title('Abe Cohabitation Coherence BLA NAcc 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_9Hz.fig');
        print(gcf,'Coherence_BLA_NACC_9Hz.png','-dpng')
        close(gcf);
        
        figure; imagesc(real(coherenceStruct.PFCwithBLA.all)');
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Abe Cohabitation Coherence PFC BLA')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_All.fig');
        print(gcf,'Coherence_PFC_BLA_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithBLA.all(:,7)),500));
        title('Abe Cohabitation Coherence PFC BLA 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_10Hz.fig');
        print(gcf,'Coherence_PFC_BLA_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithBLA.all(:,6)),500));
        title('Abe Cohabitation Coherence PFC BLA 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_9Hz.fig');
        print(gcf,'Coherence_PFC_BLA_9Hz.png','-dpng')
        close(gcf);
        
        figure; imagesc(real(coherenceStruct.PFCwithNAcc.all)');
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Abe Cohabitation Coherence PFC NACC')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_All.fig');
        print(gcf,'Coherence_PFC_NACC_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithNAcc.all(:,7)),500));
        title('Abe Cohabitation Coherence PFC NACC 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_10Hz.fig');
        print(gcf,'Coherence_PFC_NACC_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithNAcc.all(:,6)),500));
        title('Abe Cohabitation Coherence PFC NACC 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_9Hz.fig');
        print(gcf,'Coherence_PFC_NACC_9Hz.png','-dpng')
        close(gcf);
    end
end

d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Albert'

dd = dir(d);

for i = 3:length(dd)
    % check if it's a folder. 
    if dd(i).isdir
        curdir = fullfile(d,dd(i).name);
        cdd = dir(curdir);
        cd(curdir);
        % load all channels
        for j = 3:length(cdd)
          
            tf = isChanMatlabFile(cdd(j).name);
            if strcmp(cdd(j).name,'CoherenceResults.mat')
                load(fullfile(curdir,cdd(j).name));
            end
        end % end of load all channels
        figure; imagesc(real(coherenceStruct.BLAwithNAcc.all)')
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Albert Cohabitation Coherence BLA NAcc')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_All.fig');
        print(gcf,'Coherence_BLA_NACC_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.BLAwithNAcc.all(:,7)),500));
        title('Albert Cohabitation Coherence BLA NAcc 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_10Hz.fig');
        print(gcf,'Coherence_BLA_NACC_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.BLAwithNAcc.all(:,6)),500));
        title('Albert Cohabitation Coherence BLA NAcc 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_9Hz.fig');
        print(gcf,'Coherence_BLA_NACC_9Hz.png','-dpng')
        close(gcf);
        
        figure; imagesc(real(coherenceStruct.PFCwithBLA.all)');
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Albert Cohabitation Coherence PFC BLA')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_All.fig');
        print(gcf,'Coherence_PFC_BLA_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithBLA.all(:,7)),500));
        title('Albert Cohabitation Coherence PFC BLA 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_10Hz.fig');
        print(gcf,'Coherence_PFC_BLA_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithBLA.all(:,6)),500));
        title('Albert Cohabitation Coherence PFC BLA 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_9Hz.fig');
        print(gcf,'Coherence_PFC_BLA_9Hz.png','-dpng')
        close(gcf);
        
        figure; imagesc(real(coherenceStruct.PFCwithNAcc.all)');
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Albert Cohabitation Coherence PFC NACC')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_All.fig');
        print(gcf,'Coherence_PFC_NACC_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithNAcc.all(:,7)),500));
        title('Albert Cohabitation Coherence PFC NACC 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_10Hz.fig');
        print(gcf,'Coherence_PFC_NACC_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithNAcc.all(:,6)),500));
        title('Albert Cohabitation Coherence PFC NACC 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_9Hz.fig');
        print(gcf,'Coherence_PFC_NACC_9Hz.png','-dpng')
        close(gcf);
    end
end


d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Alex'

dd = dir(d);

for i = 3:length(dd)
    % check if it's a folder. 
    if dd(i).isdir
        curdir = fullfile(d,dd(i).name);
        cdd = dir(curdir);
        cd(curdir);
        % load all channels
        for j = 3:length(cdd)
          
            tf = isChanMatlabFile(cdd(j).name);
            if strcmp(cdd(j).name,'CoherenceResults.mat')
                load(fullfile(curdir,cdd(j).name));
            end
        end % end of load all channels
        figure; imagesc(real(coherenceStruct.BLAwithNAcc.all)')
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Alex Cohabitation Coherence BLA NAcc')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_All.fig');
        print(gcf,'Coherence_BLA_NACC_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.BLAwithNAcc.all(:,7)),500));
        title('Alex Cohabitation Coherence BLA NAcc 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_10Hz.fig');
        print(gcf,'Coherence_BLA_NACC_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.BLAwithNAcc.all(:,6)),500));
        title('Alex Cohabitation Coherence BLA NAcc 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_9Hz.fig');
        print(gcf,'Coherence_BLA_NACC_9Hz.png','-dpng')
        close(gcf);
        
        figure; imagesc(real(coherenceStruct.PFCwithBLA.all)');
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Alex Cohabitation Coherence PFC BLA')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_All.fig');
        print(gcf,'Coherence_PFC_BLA_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithBLA.all(:,7)),500));
        title('Alex Cohabitation Coherence PFC BLA 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_10Hz.fig');
        print(gcf,'Coherence_PFC_BLA_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithBLA.all(:,6)),500));
        title('Alex Cohabitation Coherence PFC BLA 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_9Hz.fig');
        print(gcf,'Coherence_PFC_BLA_9Hz.png','-dpng')
        close(gcf);
        
        figure; imagesc(real(coherenceStruct.PFCwithNAcc.all)');
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Alex Cohabitation Coherence PFC NACC')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_All.fig');
        print(gcf,'Coherence_PFC_NACC_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithNAcc.all(:,7)),500));
        title('Alex Cohabitation Coherence PFC NACC 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_10Hz.fig');
        print(gcf,'Coherence_PFC_NACC_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithNAcc.all(:,6)),500));
        title('Alex Cohabitation Coherence PFC NACC 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_9Hz.fig');
        print(gcf,'Coherence_PFC_NACC_9Hz.png','-dpng')
        close(gcf);
    end
end

d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Alvin'

dd = dir(d);

for i = 3:length(dd)
    % check if it's a folder. 
    if dd(i).isdir
        curdir = fullfile(d,dd(i).name);
        cdd = dir(curdir);
        cd(curdir);
        % load all channels
        for j = 3:length(cdd)
          
            tf = isChanMatlabFile(cdd(j).name);
            if strcmp(cdd(j).name,'CoherenceResults.mat')
                load(fullfile(curdir,cdd(j).name));
            end
        end % end of load all channels
        figure; imagesc(real(coherenceStruct.BLAwithNAcc.all)')
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Alvin Cohabitation Coherence BLA NAcc')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_All.fig');
        print(gcf,'Coherence_BLA_NACC_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.BLAwithNAcc.all(:,7)),500));
        title('Alvin Cohabitation Coherence BLA NAcc 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_10Hz.fig');
        print(gcf,'Coherence_BLA_NACC_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.BLAwithNAcc.all(:,6)),500));
        title('Alvin Cohabitation Coherence BLA NAcc 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_BLA_NACC_9Hz.fig');
        print(gcf,'Coherence_BLA_NACC_9Hz.png','-dpng')
        close(gcf);
        
        figure; imagesc(real(coherenceStruct.PFCwithBLA.all)');
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Alvin Cohabitation Coherence PFC BLA')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_All.fig');
        print(gcf,'Coherence_PFC_BLA_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithBLA.all(:,7)),500));
        title('Alvin Cohabitation Coherence PFC BLA 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_10Hz.fig');
        print(gcf,'Coherence_PFC_BLA_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithBLA.all(:,6)),500));
        title('Alvin Cohabitation Coherence PFC BLA 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_BLA_9Hz.fig');
        print(gcf,'Coherence_PFC_BLA_9Hz.png','-dpng')
        close(gcf);
        
        figure; imagesc(real(coherenceStruct.PFCwithNAcc.all)');
        set(gca,'ydir','normal')
        set(gca,'yticklabel',fSpect(10:10:end))
        title('Alvin Cohabitation Coherence PFC NACC')
        ylabel('Frequency (Hz)')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_All.fig');
        print(gcf,'Coherence_PFC_NACC_All.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithNAcc.all(:,7)),500));
        title('Alvin Cohabitation Coherence PFC NACC 10Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_10Hz.fig');
        print(gcf,'Coherence_PFC_NACC_10Hz.png','-dpng')
        close(gcf);
        
        figure; plot(smooth(real(coherenceStruct.PFCwithNAcc.all(:,6)),500));
        title('Alvin Cohabitation Coherence PFC NACC 9Hz')
        ylabel('Coherence')
        xlabel('Time')
        savefig(gcf,'Coherence_PFC_NACC_9Hz.fig');
        print(gcf,'Coherence_PFC_NACC_9Hz.png','-dpng')
        close(gcf);
    end
end



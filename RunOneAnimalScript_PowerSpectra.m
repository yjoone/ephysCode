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
            if tf
                load(fullfile(curdir,cdd(j).name));
            end
        end % end of load all channels
        
        figure; pwelch(Chan1(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Abe BLA Power Spectra')
        savefig(gcf,'PowerSpec_BLA.fig');
        print(gcf,'PowerSpec_BLA.png','-dpng')
        close(gcf);
        
        figure; pwelch(Chan3(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Abe NACC Power Spectra')
        savefig(gcf,'PowerSpec_NACC.fig');
        print(gcf,'PowerSpec_NACC.png','-dpng')
        close(gcf);
        
        figure; pwelch(Chan5(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Abe PFC Power Spectra')
        savefig(gcf,'PowerSpec_PFC.fig');
        print(gcf,'PowerSpec_PFC.png','-dpng')
        close(gcf);
        
        clear modStruct rasterWindowTimesSamplesStruct Chan3 Chan5 Chan1;
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
            if tf
                load(fullfile(curdir,cdd(j).name));
            end
        end % end of load all channels
        
        figure; pwelch(Chan1(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Albert BLA Power Spectra')
        savefig(gcf,'PowerSpec_BLA.fig');
        print(gcf,'PowerSpec_BLA.png','-dpng')
        close(gcf);
        
        figure; pwelch(Chan3(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Albert NACC Power Spectra')
        savefig(gcf,'PowerSpec_NACC.fig');
        print(gcf,'PowerSpec_NACC.png','-dpng')
        close(gcf);
        
        figure; pwelch(Chan5(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Albert PFC Power Spectra')
        savefig(gcf,'PowerSpec_PFC.fig');
        print(gcf,'PowerSpec_PFC.png','-dpng')
        close(gcf);
        
        clear modStruct rasterWindowTimesSamplesStruct Chan3 Chan5 Chan1;
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
            if tf
                load(fullfile(curdir,cdd(j).name));
            end
        end % end of load all channels
        
        figure; pwelch(Chan1(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Alex BLA Power Spectra')
        savefig(gcf,'PowerSpec_BLA.fig');
        print(gcf,'PowerSpec_BLA.png','-dpng')
        close(gcf);
        
        figure; pwelch(Chan3(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Alex NACC Power Spectra')
        savefig(gcf,'PowerSpec_NACC.fig');
        print(gcf,'PowerSpec_NACC.png','-dpng')
        close(gcf);
        
        figure; pwelch(Chan5(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Alex PFC Power Spectra')
        savefig(gcf,'PowerSpec_PFC.fig');
        print(gcf,'PowerSpec_PFC.png','-dpng')
        close(gcf);
        
        clear modStruct rasterWindowTimesSamplesStruct Chan3 Chan5 Chan1;
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
            if tf
                load(fullfile(curdir,cdd(j).name));
            end
        end % end of load all channels
        
        figure; pwelch(Chan15(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Alvin BLA Power Spectra')
        savefig(gcf,'PowerSpec_BLA.fig');
        print(gcf,'PowerSpec_BLA.png','-dpng')
        close(gcf);
        
        figure; pwelch(Chan3(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Alvin NACC Power Spectra')
        savefig(gcf,'PowerSpec_NACC.fig');
        print(gcf,'PowerSpec_NACC.png','-dpng')
        close(gcf);
        
        figure; pwelch(Chan5(1:1e7),[],[],[],24414);
        set(gca,'xlim',[0 0.1]);
        title('Alvin PFC Power Spectra')
        savefig(gcf,'PowerSpec_PFC.fig');
        print(gcf,'PowerSpec_PFC.png','-dpng')
        close(gcf);
        
        clear modStruct rasterWindowTimesSamplesStruct Chan3 Chan5 Chan15;
    end
end



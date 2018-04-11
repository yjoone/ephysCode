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
        
        [coherenceStruct,S1Struct,S2Struct,rasterWindowTimesSamplesStruct,fSpect] = runCoherence_ds(Chan1,Chan3,Chan5);
        save('CoherenceResults.mat', 'coherenceStruct','S1Struct','S2Struct','rasterWindowTimesSamplesStruct','fSpect');
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
        
        [coherenceStruct,S1Struct,S2Struct,rasterWindowTimesSamplesStruct,fSpect] = runCoherence_ds(Chan1,Chan3,Chan5);
        save('CoherenceResults.mat', 'coherenceStruct','S1Struct','S2Struct','rasterWindowTimesSamplesStruct','fSpect');
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
        
        [coherenceStruct,S1Struct,S2Struct,rasterWindowTimesSamplesStruct,fSpect] = runCoherence_ds(Chan1,Chan3,Chan5);
        save('CoherenceResults.mat', 'coherenceStruct','S1Struct','S2Struct','rasterWindowTimesSamplesStruct','fSpect');
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
        
        [coherenceStruct,S1Struct,S2Struct,rasterWindowTimesSamplesStruct,fSpect] = runCoherence_ds(Chan3,Chan5,Chan15);
        save('CoherenceResults.mat', 'coherenceStruct','S1Struct','S2Struct','rasterWindowTimesSamplesStruct','fSpect');
        clear modStruct rasterWindowTimesSamplesStruct Chan3 Chan5 Chan15;
    end
end



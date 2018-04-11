% script to run all the analysis on Alvin

% d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Alvin';
% d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Alex';
% d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Abe'
d = 'R:\LiuLab\People\Jim\OTmanipEphysExpt\Experiments\Albert';

dd = dir(d);

for i = 3:length(dd)
    % check if it's a folder. 
    if dd(i).isdir
        curdir = fullfile(d,dd(i).name);
        cdd = dir(curdir);
        cd(curdir);
        % load all channels
        for j = 3:length(cdd)
            tf = isMatlabFile(cdd(j).name);
            if tf
                load(fullfile(curdir,cdd(j).name));
            end
        end % end of load all channels
        [modStruct,rasterWindowTimesSamplesStruct] = runCFC_ds(Chan1,Chan3,Chan5);
        save('CFCresults.mat', 'modStruct','rasterWindowTimesSamplesStruct');
        clear modStruct rasterWindowTimesSamplesStruct Chan3 Chan5 Chan1;
    end
end



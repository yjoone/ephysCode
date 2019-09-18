% this script is to add parameters to modStruct outputs in the
% R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All
% folder

cd R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All

dd = dir(cd);

for i = 3:length(dd)
    if ~dd(i).isdir
        addParamSubroutine(dd(i).name,dd(i).folder)
    end
end


function addParamSubroutine(filename,filepath)
        load(fullfile(filepath,filename))
        modStruct.param.fhigh = fhigh;
        modStruct.param.flow = flow;
        modStruct.param.dataAcq = dataAcq;
        modStruct.param.flow = flow;
        modStruct.param.rasterWindowTimesSamplesStruct = rasterWindowTimesSamplesStruct;
        modStruct.param.startLastRangeSamples = startLastRangeSamples;
        
        namebox = strsplit(filename,'_');
        modStruct.animalID = namebox{1};
        save(fullfile(filepath,filename))
end

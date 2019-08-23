% this script is to run modStruct = analyzeModStructNoBehav(modStruct,outfilepath)
% for many animals

cd = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All';

dd = dir(cd);

for i = 3:length(dd)
    if strcmp(dd(i).name(end-3:end),'.mat')
        load(fullfile(dd(i).folder,dd(i).name))
        outfilepath = fullfile(cd,'Figures','meanNetMI');
        if ~exist(outfilepath)
            mkdir(outfilepath)
        end
        modStruct = analyzeModStructNoBehav(modStruct,outfilepath);
    end
end
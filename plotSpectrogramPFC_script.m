% script to plot PFC power spectra for all available animal data in 
% R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All\individualData

cd R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All\individualData
dd = dir(cd);
outfilepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\PFCPowerAnalysis';


for i = 3:length(dd)
    load(dd(i).name);
    fnameparts = strsplit(filename,'_');
    animalID = fnameparts{1};
    
    plotSpectrogram(dam,animalID,'outfilepath',outfilepath);
    delete dam
end
    
function neurologgerUnloadData(filepath,filename,outfilepath)

% this function takes in the .hex neurologger data file, and outputs the
% .mat data files so that it's easier to work in the matlab environment.

if nargin < 3
    outfilepath = filepath;
end

% add the code path for neurologger import function
addpath('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\ephysCode')

fullfilepath = fullfile(filepath,filename);

[datacell,samplerate] = readNL_gka(fullfilepath);

for i = 1:8
    data_temp = datacell{1}(i,:);
    switch i 
        case 1
            grnd = data_temp;
        case 2
            ref = data_temp;
        case {3,4,5,6}
            eval(['chan' num2str(i) ' = data_temp;']);
        case 7
            sync = data_temp;
        case 8
            movement = data_temp;
    end
end
outfilename = [filename(1:end-3) 'mat'];
% outfullfilepath = fullfile(outfilepath,'rawData.mat');
outfullfilepath = fullfile(outfilepath,outfilename);
save(outfullfilepath,'grnd','ref','chan3','chan4','chan5','chan6','sync','movement')

function saveHexIntoMat(filename,filepath)

% This function takes in the .hex recording files, imports it, saves each
% channel into separate variable, and saves the workspace as a .mat file

[datacell,samplerate] = readNL_gka(fullfile(filepath,filename));

grnd = datacell{1}(1,:);
ref = datacell{1}(2,:);
chan3 = datacell{1}(3,:);
chan4 = datacell{1}(4,:);
chan5 = datacell{1}(5,:);
chan6 = datacell{1}(6,:);
sync = datacell{1}(7,:);
movement = datacell{1}(8,:);

save([filename(1:end-4) '_rawData.mat'])
end
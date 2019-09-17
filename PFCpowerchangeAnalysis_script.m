expDatabasefile = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\ExperimentSummary_091619.xlsx';
recordingSite = 'PFC';
datafoldercol = 2;
rawfilenamecol = 3;
exprimentcol = 4;
recsitecol = 5;
chancol = 6;
activeperiodstart = 7;
activeperiodstop = 8;

% import excel data
[num,txt,raw] = xlsread(expDatabasefile,'RecordingData');

[r,c] = size(raw);

for i = 2:r
    indrecfile = raw{i,:};
    
    % check if the recording site is used for analysis
    if strcmpi(recordingSite,indrecfile(recsitecol))
        keyboard
    end
end

% durSecondsAnalysisWindow = input('Input desired analysis window in seconds: ');
durSecondsAnalysisWindow = 5;

if isunix
    cd(win2unix(currDir));
    path(path,win2unix(curPath));
    mdb = xlsreadMasterDBVole(win2unix(databasepath));
else
    cd(currDir);
    path(path,curPath);
    mdb = xlsreadMasterDBVole(databasepath);
end

Chronux_startup

%%
recd_AS = getrecd_mdb('LFP',mdb,{'Animal'},{'Karl'},'NeuralBehav','both');

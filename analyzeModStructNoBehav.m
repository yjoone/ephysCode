function modStruct = analyzeModStructNoBehav(modStruct,outfilepath)

% this function takes in the output of runCFC code. This input assumes no
% behavior specification, and will do global analysis of ephys signal. 

%% preprocess modStruct
% getting indices of NaN windows
modStruct = identifyNanMI(modStruct);

%% compute net MI
modStruct.netPFCtoNAcc.all = modStruct.PFCtoNAcc.all - modStruct.NAcctoPFC.all;
modStruct.netBLAtoNAcc.all = modStruct.BLAtoNAcc.all - modStruct.NAcctoBLA.all;
modStruct.netPFCtoBLA.all = modStruct.PFCtoBLA.all - modStruct.BLAtoPFC.all;

% compute the average and store it, ignoring all NaN
modStruct.netPFCtoNAcc.mean = mean(modStruct.netPFCtoNAcc.all(:,:,~modStruct.PFCtoNAcc.nani),3);
modStruct.netBLAtoNAcc.mean = mean(modStruct.netBLAtoNAcc.all(:,:,~modStruct.BLAtoNAcc.nani),3);
modStruct.netPFCtoBLA.mean = mean(modStruct.netPFCtoBLA.all(:,:,~modStruct.PFCtoBLA.nani),3);

%% plot average net MI
plotAnalyzedModStructNoBehav(modStruct,outfilepath)
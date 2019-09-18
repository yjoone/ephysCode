% this script is to add parameters to modStruct outputs in the
% R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All
% folder

cd R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Analysis\CFC_noBehav_All\individualData

dd = dir(cd);

allModStruct = struct;

for i = 3:length(dd)
    if ~dd(i).isdir
        load(fullfile(dd(i).folder,dd(i).name))
        animalID = modStruct.animalID;
        
        % compute the net MI
        allModStruct.netPFCtoNAcc.(animalID).all = modStruct.PFCtoNAcc.all - modStruct.NAcctoPFC.all;
        allModStruct.netBLAtoNAcc.(animalID).all = modStruct.BLAtoNAcc.all - modStruct.NAcctoBLA.all;
        allModStruct.netPFCtoBLA.(animalID).all = modStruct.PFCtoBLA.all - modStruct.BLAtoPFC.all;
        allModStruct.param.(animalID) = modStruct.param;
        
        % add the nan index for easy computing
        MIdataline = reshape(allModStruct.netPFCtoNAcc.(animalID).all(1,1,:),1,[]);
        nani = isnan(MIdataline);
        allModStruct.netPFCtoNAcc.(animalID).nani = nani;
        
        MIdataline = reshape(allModStruct.netBLAtoNAcc.(animalID).all(1,1,:),1,[]);
        nani = isnan(MIdataline);
        allModStruct.netBLAtoNAcc.(animalID).nani = nani;
        
        MIdataline = reshape(allModStruct.netPFCtoBLA.(animalID).all(1,1,:),1,[]);
        nani = isnan(MIdataline);
        allModStruct.netPFCtoBLA.(animalID).nani = nani;
    end
end

save('allModStruct.mat','allModStruct')
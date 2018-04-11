function [sgCFC,hCFC] = behaviorSpecificAnalysis(modStruct,BehaviorStruct,rasterWindowTimesSamplesStruct)
% quick run of analyzing CFC result based on behavior
% load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments\Alex\Cohab\CoherenceResults.mat')
% load('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments\Alex\Cohab\CFCresults.mat')

samplingrate = 24414.0625 / 48;
% cfc_data1 = modStruct.PFCtoNAcc.all;
% cfc_data2 = modStruct.NAcctoPFC.all;
cfc_data1 = modStruct.PFCtoBLA.all;
cfc_data2 = modStruct.BLAtoPFC.all;

cfc_t = rasterWindowTimesSamplesStruct.all/samplingrate;
flowStep = 1;
fhighStep = 4;
flow = 3:flowStep:21;
fhigh = 12:fhighStep:84;
outFilePath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\BehEphysAnalysis';

nBeh = length(BehaviorStruct.Behaviors);
behCFC = [];
sgCFC=[];
hCFC=[];

for i = 1:nBeh
    beh = BehaviorStruct.Behaviors(i);
    start_s = BehaviorStruct.Time_s(i);
    dur_s = BehaviorStruct.Dur_s(i);
    
    if dur_s > 5
        curT = start_s+dur_s;
        cfc_i = find(cfc_t > start_s(:,1),1); % maybe think about running -1 index
        while curT > cfc_t(cfc_i+1,2)
            cfcdata_temp = cfc_data1(:,:,cfc_i)-cfc_data2(:,:,cfc_i);
            % saveFig(cfcdata_temp,cfc_i,flow,fhigh,outFilePath);
            if beh == 5
                sgCFC = cat(3,sgCFC,cfcdata_temp);
            elseif beh == 6
                hCFC = cat(3,hCFC,cfcdata_temp);
            end
            % behCFC = cat(3,behCFC,cfc_data(:,:,cfc_i));
            cfc_i = cfc_i+1;
        end
    end
end
end

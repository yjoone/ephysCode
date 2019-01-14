% convert Observer 14 export file to 10 format for analysis



filename = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Miranda\VoleEphysProject - Miranda_Cohab_Jim - Event Logs.txt'
outfilename = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Miranda\Miranda_Habituation2AndCohab_JK_1.txt'
[num,txt,raw] = xlsread(filename);



nrow = length(raw);
outC = cell(nrow,13); %tailored for observer 10 output format
for i = 1:nrow
    line = raw{i};
    outline = '';
    linespl = strsplit(line,',');
    ci = 1;
    for c = 1:15 % specifically for observer 14
        if c ~= 1 && c ~= 5
            tempvar = linespl{c};
            if sum(ismember(tempvar,'"')) < 1
                tempvar = ['"' tempvar '"'];
            end
            outC{i,ci} = tempvar;
            ci = ci+1;
        end
    end
                
end

T = cell2table(outC);
writetable(T,outfilename,'writevariablenames',false)
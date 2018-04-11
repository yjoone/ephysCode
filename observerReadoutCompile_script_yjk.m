% script to read in and compile observer readout
% make sure current directory is where the xlsx files are stored. Too lazy
% to code that in right now


% animalIDandSide excel file path
% IDKeyFilePath = 'R:\LiuLab\People\Jim\Experiments\TwoChoiceOdorExposureExpt\AnimalIDandSide.xlsx'; 
 IDKeyFilePath = '/Users/JimKwon/Documents/emoryWorkspace/AnimalIDandSide.xlsx';

tLim = 10; %minutes

fileNames = uigetfile('*.xlsx','multiselect','on');

[num,txt,~] = xlsread(IDKeyFilePath);

len = length(fileNames);
Time_b_all = [];
Time_active = [];
shortCH = [];
longCH = [];

for i = 1:len
    fileName = fileNames{i}; % current file name
    fileName_parts = strsplit(fileName,'-');
    vidName = fileName_parts{2};
    eval(['[BehaviorStruct_' vidName '] = readObserverData(fileName);']);
    %    eval(['[Time_b_' vidName '] = compileObserverData(BehaviorStruct_' vidName ');']);
    eval(['[Time_b_' vidName '] = compileObserverData(BehaviorStruct_' vidName ',' num2str(tLim) '*60);']);
    
    Time_temp = eval(['Time_b_' vidName ]);
    txt_c = strfind(txt(:,2),vidName);
    txt_i = find(not(cellfun('isempty',txt_c)))
    
    if num(txt_i-1,4) ~= 1 && num(txt_i-1,5) == 1
        leftside_tf = num(txt_i-1,1); %subtract 1 for headers
        if ~leftside_tf % change right/left side so that row 1&3 is partner and 2&4 are strangers
            Time_temp = [Time_temp(2); Time_temp(1); Time_temp(4); Time_temp(3)];
        end
        
        % Time_b_all = cat(2,Time_b_all,Time_temp);
        Time_b_all(:,i) = Time_temp;
        Time_active = cat(2,Time_active,Time_temp);
        
        
        % cohab time
        if num(i,3) == 1
            longCH = cat(2,longCH,Time_temp);
        elseif num(i,3) == 0
            shortCH = cat(2,shortCH,Time_temp);
        else
            keyboard
        end
    end
    
    
end

exclude_i = num(:,4) == 1;
firstVid_i = num(:,5) == 1;

function [BehaviorStruct] = readObserverData(fileName)

% This function reads in the exported file from the observer. Save the file
% as a xlsx file to make import easier.

% decoder for behavior
% 1 - left sniffing
% 2 - right sniffing
% 3 - left side
% 4 - right side

% % Read in the file
% Fid = fopen(fileName);
% obsText = textscan(Fid,'%s','delimiter',',');
% fclose(Fid);

[num,txt,~] = xlsread(fileName);

% date format issue in excel. Sometimes date becomes string or number 
[~,c] = size(num)
if c ~= 5
    Dur_s = num(:,7);
    Time_s = num(:,6);
else
    % Dur_s = num(:,7);
    Dur_s = num(:,5);
    % Time_s = num(:,6);
    Time_s = num(:,4);
end


% The file should have 12 columns. 
[len,~] = size(txt);
Behaviors = zeros(len,1);

for i = 2:len %skip the header row
    switch txt{i,11}
        case 'Left Sniffing'
            Behaviors(i,1) = 1;
        case 'Right Sniffing'
            Behaviors(i,1) = 2;
        case 'Left Side'
            Behaviors(i,1) = 3;
        case 'Right Side'
            Behaviors(i,1) = 4;
        case 'Self Grooming'
            Behaviors(i,1) = 5;
        case 'Huddling'
            Behaviors(i,1) = 6;
        case 'Mounting'
            Behaviors(i,1) = 7;
    end
end

Behaviors = Behaviors(2:end,:); % get rid of the header row so it's mapped correctly to the num array

BehaviorStruct.Behaviors = Behaviors;
BehaviorStruct.Time_s = Time_s;
BehaviorStruct.Dur_s = Dur_s;

end


function output = unix2win(filepath)

% this function takes in an unix filepath and converts it to same address
% in windows

% check if the machine is already a windows. Then, don't change anything
if ~isunix
    output = filepath;
else
newfilepath = replace(filepath,'/Volumes/ecas-research/','R:\');
output = replace(newfilepath,'/','\');
end


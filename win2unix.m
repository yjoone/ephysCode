function output = win2unix(filepath)

% this function takes in an windows filepath and converts it to same address
% in unix

% check if the machine is already a unix. Then, don't change anything
if ~isunix
    output = filepath;
else
    newfilepath = replace(filepath,'R:\','/Volumes/ecas-research/');
    output = replace(newfilepath,'\','/');
end


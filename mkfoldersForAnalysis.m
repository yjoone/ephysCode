function mkfoldersForAnalysis(filepath)

% this function takes in a file path that should contain the name of the
% animal. Under that folder, this will create necessary folders for
% arrangement of the files.

basepath = filepath;

% add videos folder
vidpath = fullfile(basepath,'Videos');
mkdir(vidpath)

% add subfolders for each experiment
mkdir(fullfile(vidpath,'Habituation1'));
mkdir(fullfile(vidpath,'Habituation2'));
mkdir(fullfile(vidpath,'Cohab'));
mkdir(fullfile(vidpath,'PPT'));
mkdir(fullfile(vidpath,'StudCohab'));


% add raw files folder
vidpath = fullfile(basepath,'Videos');
mkdir(vidpath)

% add subfolders for each experiment
mkdir(fullfile(vidpath,'Habituation1'));
mkdir(fullfile(vidpath,'Habituation2'));
mkdir(fullfile(vidpath,'Cohab'));
mkdir(fullfile(vidpath,'PPT'));
mkdir(fullfile(vidpath,'StudCohab'));
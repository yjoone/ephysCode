% script to add in Liu lab matlab folders
% for OTA ephys analysis

if isunix
    
    % add in database
    addpath(win2unix('R:\LiuLab\matlab\database'))
    % add in tools
    addpath(win2unix('R:\LiuLab\matlab\tools'))
    % add in neurologger tools
    addpath(win2unix('R:\Liulab\matlab\Neurologger'));
    
    % add in pretty plotting function
    addpath(win2unix('R:\LiuLab\People\Jim\Code\raacampbell-shadedErrorBar-0dc4de5'));
    addpath(genpath(win2unix('C:\Users\ykwon36\Documents\GitHub\ephysCode\chronux_2_12_downloaded20170331')))
else% add in database
    addpath('R:\LiuLab\matlab\database')
    % add in tools
    addpath('R:\LiuLab\matlab\tools')
    % add in neurologger tools
    addpath('R:\Liulab\matlab\Neurologger');
    % add in pretty plotting function
    addpath('R:\LiuLab\People\Jim\Code\raacampbell-shadedErrorBar-0dc4de5');
    addpath(genpath('C:\Users\ykwon36\Documents\GitHub\ephysCode\chronux_2_12_downloaded20170331'))

end




% add in other codes from LA
% addpath('R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\LizAnnPipeLineExample\Neurologger_20131009')

%% script to extract background image from PPT videos

filepath = 'C:\Users\ykwon36\Dropbox\Jim\OTmanipEphysExpt\Videos\PPT';
cd(filepath)

%% run Miranda
input_video = 'Miranda_PPT.avi';
ExtractBackground
save('MirandaPPTBackground','background_frame2')

%% run Neil
input_video = 'Neil_PPT.avi';
ExtractBackground
save('NeilPPTBackground','background_frame2')


%% run Q
input_video = 'Q_PPT.avi';
ExtractBackground
save('QPPTBackground','background_frame2')


%% run O
input_video = 'O_PPT.mp4';
ExtractBackground
save('OPPTBackground','background_frame2')
% script to combine videos or M and O. Overnight

%% combine all the videos for O cohab
tic
vidpath = 'C:\Users\ykwon36\Dropbox\VideosFromYerkes\VideoTransfer_NeilAndO\O Habituation2AndCohab';
outvidname = 'Habituation2_And_Cohab_O.mpeg';
combineVideos(vidpath,outvidname)
toc
%% combine all the videos for M cohab
tic
vidpath = 'C:\Users\ykwon36\Dropbox\VideosFromYerkes\VideoTransfer_LarryAndMiranda\Miranda\Habituation2_And_Cohab\IndividualVideoFiles_Cohab';
outvidname = 'Cohab_Miranda.mpeg';
combineVideos(vidpath,outvidname)
toc
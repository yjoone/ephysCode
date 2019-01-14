function combineVideos(vidpath,outvidname)

% This function will take in all the videos in the input specified folder,
% and combines all to make a new single file video. 

% This function assumes that the alphanumeric sorting of the file names
% will be in chronological order.

if nargin < 2
    outvidname = inputdlg('Enter the name of output video file');
end

resizeratio = .7;

%% get the directory file info before creating the output video

dd = dir(vidpath);

%% create an output video object
vout = VideoWriter(fullfile(vidpath,outvidname),'MPEG-4');
% set(vout,'CompressionRatio',20)
open(vout)
%% grab all the file info in the vidpath folder

for i = 3:numel(dd)
    filename = dd(i).name;
    vo = VideoReader(fullfile(vidpath,filename));
    while hasFrame(vo)
        writeVideo(vout,imresize(readFrame(vo),resizeratio));
    end
    display(['Finished writing ' num2str(i) ' video']);
end

close(vout)
function combineVideos(vidpath,outvidname,outvidpath)

% This function will take in all the videos in the input specified folder,
% and combines all to make a new single file video. 

% This function assumes that the alphanumeric sorting of the file names
% will be in chronological order.

% edited outvidname (input arg 2) to include outpath info. JK 040919

if nargin < 2
    outvidname = inputdlg('Enter the name of output video file');
elseif nargin < 3
    outvidpath = vidpath;
end

resizeratio = .7;

%% get the directory file info before creating the output video

dd = dir(vidpath);

%% create an output video object
vout = VideoWriter(fullfile(outvidpath,outvidname),'MPEG-4');
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
function convertAllVideosToAvi(filepath,outfilename,outfilepath)

%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%
% THIS FUNCTION ASSUMES THAT THE VIDEO FILES %
% ARE IN CHRONOLOGICAL ORDER %%%%%%%%%%%%%%%%%


if nargin < 2
    outfilename = 'combinedvideo';
    outfilepath = filepath;
elseif nargin < 3
    outfilepath = filepath;
end

%% initialize the output video objective
outfullfilepath = fullfile(outfilepath,[outfilename '.avi']);
vOut = VideoWriter(outfullfilepath,'Motion JPEG AVI');
open(vOut);


%% get all the video files in the path
dd = dir(filepath);

for i = 3:length(dd)
    vidfilename = dd(i).name;
    vo = VideoReader(fullfile(filepath,vidfilename));
    while hasFrame(vo)
        writeVideo(vOut,readFrame(vo));
    end
end
close(vOut);
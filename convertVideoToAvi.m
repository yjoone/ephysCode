function convertVideoToAvi(fullfilepath,outfilepath)

if nargin < 2
    [filepath,~,~] = fileparts(fullfilepath);
    outfilepath = filepath;
end

% read in the video objective
vo = VideoReader(fullfilepath);

% initialize the output video objective
[~,name,~] = fileparts(fullfilepath);
outfilename = [name '.avi'];
outfullfilepath = fullfile(outfilepath,outfilename);
vOut = VideoWriter(outfullfilepath,'Motion JPEG AVI');
open(vOut);

% read and write frame by frame
while hasFrame(vo)
    writeVideo(vOut,readFrame(vo));
end

close(vOut);
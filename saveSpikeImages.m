function saveSpikeImages(videoFilePath,spikeFrame)

% This function saves images of the video when the spike takes place. 

% read video in
vo = VideoReader(videoFilePath);

% get the video folder so that the images can be saved there
[outPath] = fileparts(videoFilePath);

spikeN = length(spikeFrame);

figure
for i = 1:spikeN
    I = read(vo,spikeFrame(i));
    imagesc(I);
    outIFilePath = fullfile(outPath,['spikeImage_' num2str(i) '.jpeg']);
    print(outIFilePath,'-djpeg');
end

clear vo;
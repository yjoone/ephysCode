function [LED,framerate] = ExtractLEDbrightness(filepath,filename,varargin)
% function modified from ExtractLEdBrightness_script

plotTF = 'on';
assign(varargin)

if ~exist('LEDpos',1)
    vo = VideoReader(fullfile(filepath,filename));
    figure; imagesc(readFrame(vo));
    title(['Click on the LED position. If having trouble, independently load the video and find LEDpos'])
    waitforbuttonpress;
    % Determine the current point
    Cp = get(gca,'CurrentPoint');
    Xp = Cp(2,1);  % X-point
    Yp = Cp(2,2);  % Y-point
    LEDpos = [Xp, Yp];
end

% video location & LED location
% filepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Franz\Videos\Habituation1';
% filename = '2018-09-20 18_39_02.avi';
% filepath = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\Experiments_NL\Neil'
% filename = 'Habituation2_and_Cohab_Neil_113018.avi';
% LEDpos = [213+23,541+21];
% LEDpos = [183, 183];
% LEDpos = [409,27]; % LA sample pipeline video. JK 122918
% LEDpos = [181,182]; %for Neil Cohab. JK
% rbgChan = 1; % RBG in channel 123 respectively

% set up the video object
fullfilepath = fullfile(filepath,filename);
v = VideoReader(fullfilepath);
framerate = v.FrameRate;

% load in the video frame by frame and extract the LED light brightness
i = 1;
while hasFrame(v)
    I_temp = readFrame(v);
    LED(i) = I_temp(LEDpos(1),LEDpos(2),1);
    i = i+1;
end

if strcmpi(plotTF,'on')
    
    figure;
    plot(LED,'.')
    title('LED activity during recording')
    xlabel('Samples (NL sample)')
    ylabel('Red channel brightness')

    % save the data and figure
    save(fullfile(filepath,'LEDbySampleTimes.mat'),{'LED','framerate'});
    savefig(fullfile(filepath,'LEDbySampleTimes.fig'));
    print(gcf,fullfile(filepath,'LEDbySampleTimes.png'),'-dpng')
end
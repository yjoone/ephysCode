function [LEDtriggers,LEDvideoNumMat,centroids] = DetectLED3(videoFilename,videoNum,varargin)
% Script to detect periodic sets of light flashes from a red LED (flashes white). 
% To detect flashes, looks for red in video frame, assumes that LED is the only red object and
% that it is not flashing in the first video frame. Computes centroid of red area (~center of bulb) and uses as a reference point to detect change in color (flash). 
% Since LED can move during the video (e.g. jostled when move animal's 
% cage), catch in code to re-compute centroid if LED flash not detected
% within expected period. 

pixelValFlash = [192 192 192]; % 1x3 matrix indicating color of a pixel with values from 0 to 255; white is [255 255 255]. Here, have a slightly more relaxed criteria [>=192 >=192 >=192] in case flashing bulb not perfectly white 
refFrame = 1; % for detecting position (centroid) of LED; LED should not be flashing
startFrame = 1;
imageCropParams = [0 150 240 200];
assign(varargin{:});
voleObj=VideoReader(videoFilename);

pixelValFlash

threshOrig = 0.3; % a measure of how much contrast used to detect red in frame
threshStep = 0.01;
frameRate = voleObj.FrameRate;
minDurationBtwnFlashes = 0.064; % if using Synchro box to deliver LED flashes, each trigger produces multiple flashes in a pattern. Minimum time between two flashes in Synchrobox pattern
numFramesDistPattern = ceil(frameRate*minDurationBtwnFlashes); % numFramesDistPattern allows detect only first LED flash in each pattern by specifying a minimum distance in frames between flashes to distinguish a pattern
totalNumFrames = voleObj.NumberOfFrames;
expectPeriodFramesBtwnTriggers = 100; % expected period between sets of LED flashes
jitter = floor(expectPeriodFramesBtwnTriggers/10); % in case period is not exactly what specify above
numFramesJump = expectPeriodFramesBtwnTriggers-jitter; % only scan a portion of frames where expect LED flash could occur 
%centroids = [];


% detect centroid of LED in ref image:

% first establish region of image (boundBox) to look for centroid (in ref
% frame)
thresh = threshOrig;
image = read(voleObj,refFrame);
image = imcrop(image,imageCropParams);
diff = imsubtract(image(:,:,1),rgb2gray(image));
diffPixelated = im2bw(diff,thresh);
sTest = regionprops(diffPixelated,'centroid');
if isempty(sTest) % if do not detect red object, contrast (thresh) level may be set too high
    while isempty(sTest) 
        thresh = thresh-threshStep;
        diffPixelated = im2bw(diff,thresh);
        sTest = regionprops(diffPixelated,'centroid');
    end
end
s = sTest; % assumes that LED bulb is the strongest red object in screen
centroidPoint=s.Centroid; % will throw error if detects other red objects in screen at given thresh value
boundBox = [centroidPoint(1)-15,centroidPoint(2)-20,45,60]; % assume red light won't jostle outside this box
sizeFrame = size(diff);
if boundBox(1)<0
    boundBox(1)=0;
end
if boundBox(2)<0
    boundBox(2) = 0;
end
if boundBox(1)+boundBox(3)>sizeFrame(2)
    boundBox(3) = sizeFrame(1)-boundBox(1);
end
if boundBox(2)+boundBox(4)>sizeFrame(1)
    boundBox(4) = sizeFrame(1)-boundBox(2);
end


% then detect centroid in ref frame
image = read(voleObj,refFrame);
image = imcrop(image,imageCropParams);
image = imcrop(image,boundBox);
diff = imsubtract(image(:,:,1),rgb2gray(image));
diffPixelated = im2bw(diff,thresh);
sTest = regionprops(diffPixelated,'centroid');
if isempty(sTest) % if do not detect red object, contrast (thresh) level may be set too high
    while isempty(sTest) 
        thresh = thresh-threshStep;
        diffPixelated = im2bw(diff,thresh);
        sTest = regionprops(diffPixelated,'centroid');
    end
end
s = sTest; % assumes that LED bulb is the strongest red object in screen
centroidPoint=s.Centroid;

% find LED triggers
LEDtriggers = [];
centroids = [];
endFrame = totalNumFrames;
i = startFrame;
calcCentroid = 0; % set to 0 or 1; if 1, calculate a centroid
while i<=endFrame;
    image = read(voleObj,i);
    image = imcrop(image,imageCropParams);
    image = imcrop(image,boundBox);

    sizeLEDtriggers = size(LEDtriggers,2);
    if isempty(LEDtriggers) % if passed jitter range and still haven't detected trigger
        if i>(expectPeriodFramesBtwnTriggers+jitter)&&image(round(centroidPoint(2)),round(centroidPoint(1)),1)<pixelValFlash(1)&&image(round(centroidPoint(2)),round(centroidPoint(1)),2)<pixelValFlash(2)&&image(round(centroidPoint(2)),round(centroidPoint(1)),3)<pixelValFlash(3) % "image" parts of if statement account for possibility that, when LED moved, something white (not flashig bulb) moved into position where original centroid was; don't want to falsely detect flashing bulb
            calcCentroid=1;
        end
    elseif ~isempty(LEDtriggers) % if passed jitter range and still haven't detected trigger
        if (i-LEDtriggers(sizeLEDtriggers))>(expectPeriodFramesBtwnTriggers+jitter)&&image(round(centroidPoint(2)),round(centroidPoint(1)),1)<pixelValFlash(1)&&image(round(centroidPoint(2)),round(centroidPoint(1)),2)<pixelValFlash(2)&&image(round(centroidPoint(2)),round(centroidPoint(1)),3)<pixelValFlash(3)
            calcCentroid=1;
        end
    end   

    if isequal(calcCentroid,1) 
        thresh = threshOrig; % updated starting in November 2015 (starting with subject PV20151006B analysis) to re-set threshold to original value (previously used threshold set in inital detection of red LED); this account for possibility of change lighting which would require a higher threshold to detect LED
        diff = imsubtract(image(:,:,1),rgb2gray(image));
        diffPixelated = im2bw(diff,thresh);
        sTest = regionprops(diffPixelated,'centroid');
        if isempty(sTest) % if do not detect red object, contrast (thresh) level may be set too high
            while isempty(sTest) 
                thresh = thresh-threshStep;
                diffPixelated = im2bw(diff,thresh);
                sTest = regionprops(diffPixelated,'centroid');
            end
        end
        s = sTest; % assumes that LED bulb is the strongest red object in screen
        centroidPoint=s.Centroid; % will throw error if detects other red objects in screen at given thresh value
    end


    %centroids = [centroids; centroidPoint];
    %image(round(centroidPoint(2)),round(centroidPoint(1)),1);
    %image(round(centroidPoint(2)),round(centroidPoint(1)),2);
    %image(round(centroidPoint(2)),round(centroidPoint(1)),3);
    if image(round(centroidPoint(2)),round(centroidPoint(1)),1)>=pixelValFlash(1)&&image(round(centroidPoint(2)),round(centroidPoint(1)),2)>=pixelValFlash(2)&&image(round(centroidPoint(2)),round(centroidPoint(1)),3)>=pixelValFlash(3)
        if sizeLEDtriggers==0;
            LEDtriggers = [LEDtriggers i];
            i
        else
            if (i-LEDtriggers(sizeLEDtriggers))>numFramesDistPattern % check that only detecting first LED flash in a given set/pattern
                LEDtriggers = [LEDtriggers i];
                centroids = [centroids centroidPoint];
                i
            end
        end
        i = i + numFramesJump;
        calcCentroid = 1;
    else
        i= i+1;
        calcCentroid = 0;
        %i
    end
end
LEDtriggers = LEDtriggers-1; %see lab notebook 4; page 121
LEDvideoNumMat = videoNum*ones(1,numel(LEDtriggers));
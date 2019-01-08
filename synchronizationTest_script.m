clear all;
load('synchronizationAllData.mat')
jitterFramePercent = 20;

% identify the first synchronization pulses
synced = [refFrame1 refIR1];

% for each of the video pulses (assumed to be more reliable than IR),
% identify the next pulse frame number for IR data
nFrame = numel(triggerpointsLED);

% compute the conversion ratio
frameToIR = samplerate/framerate;
% iIR = 2;
currSample = refIR1; % first point is the sync reference. Start from there

for i = 2:nFrame
    dFrame = triggerpointsLED(i) - triggerpointsLED(i-1);
    % dIR = triggerpointsIR(iIR) - triggerpointsIR(iIR-1);
%             if i == 4871
%             keyboard
%         end
    expSample = currSample + dFrame*frameToIR;
    % expSample = currSample + pulseRate*framerate*frameToIR;
    expJitter = dFrame*(jitterFramePercent/100)*frameToIR;
    if isempty(triggerpointsIR(triggerpointsIR >= (expSample-expJitter)...
            &triggerpointsIR <= (expSample+expJitter)))
        currSample = expSample;
        synced = [synced; triggerpointsLED(i) placeholderVal];
        if contmiss > 5
            i
            contmiss = 1;
        end
        contmiss = contmiss+1;
        

    else
        currSample = triggerpointsIR(triggerpointsIR >= (expSample-expJitter)...
            &triggerpointsIR <= (expSample+expJitter));
        synced = [synced; triggerpointsLED(i) currSample];
        contmiss = 1;
    end
end
numel(find(synced == -1))

if length(triggerpointsLED) ~= length(synced)
    display('Synchrnonization did not work correctly. Go find the bug!')
    keyboard
end

if synced(end,1) ~= refFrame2 || synced(end,2) ~= refIR2
    display('Synchrnonization did not work correctly. Go find the bug!')
    keyboard
end
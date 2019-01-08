function[behav_samples]=EstimateSamplesNL(epocharray,fullfilenameTimestampLog,experimentFilepath,sortedSoftwareCell,varargin)
% Input:
% Matrix Nx3 dimensions; each row is a separate trial (N trial total),
% first column: video number, second column: trial starts (frames), third
% column: trial ends (frames) 
% timestamp log should be in same format, except each row is a timestamp

% Output:
% Matrix with Nx2; first column: trial starts (samples); second column:
% trial ends (samples);
%
% Assumptions: 1) All Cleversys timestamps matched with LED timestamps (e.g. no situations where a trigger signal was delivered but not recorded in Cleversys excel record or produced/detected as light pulse in video), 
% 2) LED timestamps in chronological order (see error check below), 3) LED timestamp occurs 
% slightly later than Cleversys timestamp but does not exceed 100 frames greater than Cleversys timestamp, 3) record of LED timestamps covers at least period of Cleversys timestamps
% 4) If behavior frame occurs on or after last timestamp, last and second to last
% timestamp must have correspondng samples (no placeholders) --> otherwise, will throw error, 5) If
% behavior frame occurs on or before first timestamp, first and second timestamp
% must have corresponding samples (no placeholders) --> otherwise, will throw error.
%
% Changes from version in Neurologger_20130410: 1) Still using regression with video and neural data timestamps to estimate sample 
% corresponding to a given frame, but using LED timestamps as opposed to Cleversys timestamps as the "video timestamps" 
% in this regression. Using Cleversys timestamps only to match LED timestamps and corresponding
% neural timestamps. 2) Flooring, as opposed to rounding, the regression
% estimate of samples. 
%
%

assign(varargin{:});

load(fullfile(experimentFilepath,'TimestampLogKey.mat')); % from CreateTimestampLogNL.m
load(fullfile(experimentFilepath,'BehaviorTemplateKey.mat')); % from CreatBehaviorTemplate.m

orderVideoNumStartStop = [videonumOutputColumn behavStartTimeFramesOutputColumn behavStopTimeFramesOutputColumn behavStartTimeSecondsOutputColumn behavStartTimeSecondsOutputColumn];
VideoNumStartStopNew = zeros(1,numel(orderVideoNumStartStop));
if behavIDOutputColumn==1;
    VideoNumStartStopNew(orderVideoNumStartStop==2)=1;
    VideoNumStartStopNew(orderVideoNumStartStop==3)=2;
    VideoNumStartStopNew(orderVideoNumStartStop==4)=3;
    VideoNumStartStopNew(orderVideoNumStartStop==5)=4;
    VideoNumStartStopNew(orderVideoNumStartStop==6)=5;
elseif behavIDOutputColumn==2;
    VideoNumStartStopNew(orderVideoNumStartStop==1)=1;
    VideoNumStartStopNew(orderVideoNumStartStop==3)=2;
    VideoNumStartStopNew(orderVideoNumStartStop==4)=3;
    VideoNumStartStopNew(orderVideoNumStartStop==5)=4;
    VideoNumStartStopNew(orderVideoNumStartStop==6)=5;
elseif behavIDOutputColumn==3;
    VideoNumStartStopNew(orderVideoNumStartStop==1)=1;
    VideoNumStartStopNew(orderVideoNumStartStop==2)=2;
    VideoNumStartStopNew(orderVideoNumStartStop==4)=3;
    VideoNumStartStopNew(orderVideoNumStartStop==5)=4;
    VideoNumStartStopNew(orderVideoNumStartStop==6)=5;
elseif behavIDOutputColumn==4;
    VideoNumStartStopNew(orderVideoNumStartStop==1)=1;
    VideoNumStartStopNew(orderVideoNumStartStop==2)=2;
    VideoNumStartStopNew(orderVideoNumStartStop==3)=3;
    VideoNumStartStopNew(orderVideoNumStartStop==5)=4;
    VideoNumStartStopNew(orderVideoNumStartStop==6)=5;
elseif behavIDOutputColumn==5;
    VideoNumStartStopNew(orderVideoNumStartStop==1)=1;
    VideoNumStartStopNew(orderVideoNumStartStop==2)=2;
    VideoNumStartStopNew(orderVideoNumStartStop==3)=3;
    VideoNumStartStopNew(orderVideoNumStartStop==4)=4;
    VideoNumStartStopNew(orderVideoNumStartStop==6)=5;
elseif behavIDOutputColumn==6;
    VideoNumStartStopNew(orderVideoNumStartStop==1)=1;
    VideoNumStartStopNew(orderVideoNumStartStop==2)=2;
    VideoNumStartStopNew(orderVideoNumStartStop==3)=3;
    VideoNumStartStopNew(orderVideoNumStartStop==4)=4;
    VideoNumStartStopNew(orderVideoNumStartStop==5)=5;
end

videoNumColumn = VideoNumStartStopNew(1);
epochsFramesStartColumn = VideoNumStartStopNew(2);
epochsFramesStopsColumn = VideoNumStartStopNew(3);
  
        
N = size(epocharray,1);
behav_samples = zeros(N,2); 


timestamplogRead = xlsread(fullfilenameTimestampLog);


% Create an Nx3 array with trial starts in first column, trial ends in
% second, and video number in third
behavior = horzcat(epocharray(:,epochsFramesStartColumn),epocharray(:,epochsFramesStopsColumn),epocharray(:,videoNumColumn));

for i = 1:N
    video_num = behavior(i,3);
    softwarei = sortedSoftwareCell{i}; % added LA 4/29/14
    
    % Read in Cleversys timestamps
    index = find(timestamplogRead(:,vid_num_index)==video_num);
    vidFramesCleversys = timestamplogRead(index,vid_frames);
    
    % Read in LED timestamps
    LEDtriggersVid = LEDtriggers(LEDvideoNumMat==video_num);
    
    % Check that both sets of timestamps are in ascending order;
    if ~isequal(vidFramesCleversys,sort(vidFramesCleversys)) || ~isequal(LEDtriggersVid,sort(LEDtriggersVid)) 
        error('timestamps not in ascending order')
    end

    % Check that have a consistent number of LED and Cleversys timestamps 
    numCleversysTriggers = numel(vidFramesCleversys);
    numLEDtriggers = numel(LEDtriggersVid);
    
    if ~isequal(numLEDtriggers,numCleversysTriggers)

        error('Unequal number of LED and Cleversys timestamps')
    end
    
    % Check that LED timestamps occur after corresponding Cleversys
    % timestamps and before next one -- added LA 5/16/14
    diffClevLED = LEDtriggersVid-vidFramesCleversys;
    if ~isempty(find(diffClevLED<=0,1))
        error('At least one LED timestamp does not occur after respective Cleversys timestamp')
    end
    
    clevTriggersShift = [vidFramesCleversys(2:end);vidFramesCleversys(1)];
    diffClevLEDshift = clevTriggersShift - LEDtriggersVid;
    if ~isempty(find(diffClevLEDshift(1:(end-1))<=0,1))
        error('At least one LED timestamp occurring on or after next Cleversys timestamp')
    end
    
    for j = 1:2
        behaviorFrame = behavior(i,j);
        
        switch softwarei % added LA 4/29/14
            case 'Observer'
                behaviorFrame = behaviorFrame + 1; % Observer starts at frame 0, Matlab at frame 1 -- to convert Observer time into Matlab time, add 1. Important for comparing behavior frame from Observer with LEDtriggers, which are in Matlab time
        end
        
        LEDtriggersVid_shift = [LEDtriggersVid(2:end);LEDtriggersVid(1)]; % modulo by 1; use to locate a video frame between two LED triggers/timestamps
        
        frameFallsLEDtrigger = find(behaviorFrame==LEDtriggersVid);
        % Identify closest LEDtrigger below given frame
        if ~isempty(frameFallsLEDtrigger) % exception: behavior frame occurs at same time as an LED timestamp
            if isequal(frameFallsLEDtrigger,numel(LEDtriggersVid)) % behavior frame occurs at the same time as last LED timestamp
                ID_in_between = numel(LEDtriggersVid)-1;
            else % behavior frame occurs at same time as any other timestamp (including first)
                ID_in_between = frameFallsLEDtrigger;
            end
        else % behavior frame does not occur at same time as an LED timestamp
            if behaviorFrame>LEDtriggersVid(end) % behavior frame occurs after last timestamp
                ID_in_between = numel(LEDtriggersVid)-1;
            elseif behaviorFrame<LEDtriggersVid(1) % behavior frame occurs before first timestamp
                ID_in_between = 1;
            else
                ID_in_between = find(behaviorFrame>LEDtriggersVid & behaviorFrame<LEDtriggersVid_shift);
            end
        end
        % find two adjacent timestamps in LED record: upper and lower
        % bounds
        framesLEDLower = LEDtriggersVid(ID_in_between);
        framesLEDUpper = LEDtriggersVid(ID_in_between+1);
        
                         
      
        % now match LED and Cleversys timestamps       
        if behaviorFrame>=LEDtriggersVid(end) % behavior frame occurs on or after last timestamp
            framesCleversysLower = vidFramesCleversys(end-1); % consistent with ID_in_between above
            framesCleversysUpper = vidFramesCleversys(end);
        elseif behaviorFrame<=LEDtriggersVid(1) % behavior frame occurs on or before first timestamp
            framesCleversysLower = vidFramesCleversys(1); % consistent with ID_in_between above
            framesCleversysUpper = vidFramesCleversys(2);
        else
            LEDClevLower = framesLEDLower-vidFramesCleversys;
            LEDClevUpper = -framesLEDUpper+vidFramesCleversys;
            
            [LEDClevLowerSort,LEDClevLowerSortIndex] = sort(LEDClevLower);
            [LEDClevUpperSort,LEDClevUpperSortIndex] = sort(LEDClevUpper);
        
            LEDClevLowerSortFirstPosID = find(LEDClevLowerSort>0,1);
            backToOriginalIDLower = LEDClevLowerSortIndex(LEDClevLowerSortFirstPosID);
            framesCleversysLower = vidFramesCleversys(backToOriginalIDLower);
            
            LEDClevUpperSortFirstPosID = find(LEDClevUpperSort>0,1);
            if isempty(LEDClevUpperSortFirstPosID) % LA added conditional 12/6/2015 because noticed error when behavior frame value between second-to-last and last timestamp
                [aa,LEDClevUpperSortFirstPosID] = max(LEDClevUpperSort);
                display(['Confirm behavior frame ', num2str(behaviorFrame),' between last and second-to-last timestamps']);
            else
                LEDClevUpperSortFirstPosID = LEDClevUpperSortFirstPosID-1;
            end
            backToOriginalIDUpper = LEDClevUpperSortIndex(LEDClevUpperSortFirstPosID);
            framesCleversysUpper = vidFramesCleversys(backToOriginalIDUpper);
        end
        
        % Now that have Cleversys timestamps, need to see whether
        % there are neural samples or placeholders (couldn't detect neural samples) associated with these
        vidSamplesCleversys = timestamplogRead(index,neural_samples);
        
        % check same number of vidSamplesCleversys as LED timestamps
        if ~isequal(numel(LEDtriggersVid),numel(vidSamplesCleversys))
            error('Discrepancy in number of sample and LED timestamps')
        end
        
        if behaviorFrame>=LEDtriggersVid(end) % behavior frame occurs on or after last timestamp
            
            indexLower = numel(LEDtriggersVid)-1;
            indexUpper = numel(LEDtriggersVid);
            
            samplesCleversysLower = vidSamplesCleversys(indexLower);  % consistent with ID_in_between above
            samplesCleversysUpper = vidSamplesCleversys(indexUpper);
            
            if isequal(samplesCleversysLower,placeholderVal) || isequal(samplesCleversysUpper,placeholderVal) % if either of samples are placeholders, need to adjust to closest timestamps without placeholders
                if isequal(samplesCleversysLower,placeholderVal) && ~isequal(samplesCleversysUpper,placeholderVal)
                    while isequal(samplesCleversysLower,placeholderVal)
                        indexLower = indexLower - 1;
                        samplesCleversysLower = vidSamplesCleversys(indexLower);
                    end
                elseif isequal(samplesCleversysUpper,placeholderVal)
                    while isequal(samplesCleversysUpper,placeholderVal)
                        indexUpper = indexUpper-1;
                        samplesCleversysUpper = vidSamplesCleversys(indexUpper);
                    end
                    
                    if indexLower>=indexUpper
                        indexLower = indexUpper-1;
                        samplesCleversysLower = vidSamplesCleversys(indexLower);
                        if isequal(samplesCleversysLower,placeholderVal) % check if lower timestamp is now on a placeholder and adjust if necessary
                            while isequal(samplesCleversysLower,placeholderVal)
                                indexLower = indexLower-1;
                                samplesCleversysLower = vidSamplesCleversys(indexLower);
                            end
                        end   
                    end
                end
                
%                 while isequal(samplesCleversysLower,placeholderVal) || isequal(samplesCleversysUpper,placeholderVal)
%                     indexLower = indexLower-1;
%                     indexUpper = indexUpper-1;
%                     samplesCleversysLower = vidSamplesCleversys(indexLower);
%                     samplesCleversysUpper = vidSamplesCleversys(indexUpper);
%                 end
            end
            
            framesLEDLower = LEDtriggersVid(indexLower);
            framesLEDUpper = LEDtriggersVid(indexUpper);                   
            
        elseif behaviorFrame<=LEDtriggersVid(1) % behavior frame occurs on or before first timestamp
            
            indexLower = 1;
            indexUpper = 2;
            
            samplesCleversysLower = vidSamplesCleversys(indexLower);  % consistent with ID_in_between above
            samplesCleversysUpper = vidSamplesCleversys(indexUpper);
            
            if isequal(samplesCleversysLower,placeholderVal) || isequal(samplesCleversysUpper,placeholderVal) % if either of samples are placeholders, need to adjust to closest timestamps without placeholders
                if ~isequal(samplesCleversysLower,placeholderVal) && isequal(samplesCleversysUpper,placeholderVal)
                    while isequal(samplesCleversysUpper,placeholderVal)
                        indexUpper = indexUpper + 1;
                        samplesCleversysUpper = vidSamplesCleversys(indexUpper);
                    end
                elseif isequal(samplesCleversysLower,placeholderVal)
                    while isequal(samplesCleversysLower,placeholderVal)
                        indexLower = indexLower+1;
                        samplesCleversysLower = vidSamplesCleversys(indexLower);
                    end
                    
                    if indexUpper<=indexLower
                        indexUpper = indexLower+1;
                        samplesCleversysUpper = vidSamplesCleversys(indexUpper);
                        while isequal(samplesCleversysUpper,placeholderVal)
                            indexUpper = indexUpper+1;
                            samplesCleversysUpper = vidSamplesCleversys(indexUpper);
                        end
                    end
                end
                    
                    
                    
%                 while isequal(samplesCleversysLower,placeholderVal) || isequal(samplesCleversysUpper,placeholderVal)
%                     indexLower = indexLower+1;
%                     indexUpper = indexUpper+1;
%                     samplesCleversysLower = vidSamplesCleversys(indexLower);
%                     samplesCleversysUpper = vidSamplesCleversys(indexUpper);
%                 end
            end
            
            framesLEDLower = LEDtriggersVid(indexLower);
            framesLEDUpper = LEDtriggersVid(indexUpper);
            
        else % Updated LA on Jan 18, 2016 to include case where all earlier timestamps to behaviorFrame are placeholders
            %behaviorFrame
            samplesCleversysLower = vidSamplesCleversys(backToOriginalIDLower);
            samplesCleversysUpper = vidSamplesCleversys(backToOriginalIDUpper);
            
            switchIncreaseLowerAdjust = 0;
            if isequal(samplesCleversysLower,placeholderVal) % if placeholder, find closest earlier Cleversys timestamp associated with a neural sample (new lower bound)
                IDLowerAdjust = backToOriginalIDLower;
                while isequal(samplesCleversysLower,placeholderVal)
                    if ~isequal(switchIncreaseLowerAdjust,1) % unless all earlier timestamps are placeholders (also see next if statement), in which case find first later non-placeholder timestamp
                        IDLowerAdjust = IDLowerAdjust-1;
                    else
                        IDLowerAdjust = IDLowerAdjust+1;
                    end
                    if ~isequal(IDLowerAdjust,0)
                        samplesCleversysLower = vidSamplesCleversys(IDLowerAdjust);
                    else 
                        switchIncreaseLowerAdjust = 1;
                    end
                end
                newFramesCleversysLower = vidFramesCleversys(IDLowerAdjust);
                framesLEDLower = LEDtriggersVid(find(LEDtriggersVid>newFramesCleversysLower,1)); % assuming LED triggers are in chronological order and occur slightly after corresponding Cleverys timestamp (but before next Cleverys timestamp), verified above
            end
            
            if isequal(switchIncreaseLowerAdjust,1)
                samplesCleversysUpper = vidSamplesCleversys(IDLowerAdjust+1);
                IDUpperAdjust = IDLowerAdjust+1;
                newFramesCleversysUpper = vidFramesCleversys(IDUpperAdjust);
                framesLEDUpper = LEDtriggersVid(find(LEDtriggersVid>newFramesCleversysUpper,1));
            else
                IDUpperAdjust = backToOriginalIDUpper;
            end
                         
            if isequal(samplesCleversysUpper,placeholderVal) % if placeholder, find closest later Cleversys timestamp associated with a neural sample (new upper bound)
                while isequal(samplesCleversysUpper,placeholderVal)
                    IDUpperAdjust = IDUpperAdjust+1;
                    samplesCleversysUpper = vidSamplesCleversys(IDUpperAdjust);
                end
                newFramesCleversysUpper = vidFramesCleversys(IDUpperAdjust);
                framesLEDUpper = LEDtriggersVid(find(LEDtriggersVid>newFramesCleversysUpper,1)); % assuming LED triggers are in chronological order
            end
        end
                      
        % behav_samples(i,j)=regression(behaviorFrame,framesLEDLower,framesLEDUpper,samplesCleversysLower,samplesCleversysUpper);
               behav_samples(i,j)=regression1(behaviorFrame,framesLEDLower,framesLEDUpper,samplesCleversysLower,samplesCleversysUpper);
    end
end

behav_samples = floor(behav_samples);

end


        

%Assumptions: time out to ms, only 1 video, behavior data in Observer .txt
%format
% Note: can indicate that only want to compare epochs of at least a
% specific duration: timeDurationThreshSeconds; if want to include all
% epochs, set timeDurationThreshSeconds to 0

iterfilename_Scorer1 = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\VideoScoring\ScoringPractice\VoleEphysProject-BehaviorScoringExamples-Event Logs.txt';%'F:\Analysis\Matlab\TrainingJimVoleScoring\cohab_nomanip_consolidated-Wittney_FINAL_EXAM_MASTER-Event Logs.txt';%'R:\LiuLab\People\Liz Ann\ReliabilityAnalysisObserverFiles\cohab_nomanip_consolidated-Rasika_Final_Exam-Event Logs.txt';%'G:\cohab_nomanip_consolidated-Lily_FINAL_EXAM-Event Logs.txt';%'F:\Experiments\PV20130929B\20131004\PV20130929B_20131004_AS_1.txt'; %'F:\Experiments\PV20130929B\20131004\PV20130929B_20131004_AS_1.txt'
iterfilename_Scorer2 = 'R:\LiuLab\People\Jim\Experiments\OTmanipEphysExpt\VideoScoring\ScoringPractice\VoleEphysProject-PracticeBehaviorScoring_Amelie-Event Logs.txt';%'R:\LiuLab\People\Liz Ann\ReliabilityAnalysisObserverFiles\cohab_nomanip_consolidated-Wittney_FINAL_EXAM_MASTER-Event Logs.txt';%'G:\cohab_nomanip_consolidated-Wittney_FINAL_EXAM_MASTER-Event Logs.txt';%'F:\Experiments\PV20130929B\20131004\PV20130929B_20131004_WM_1.txt'; %'F:\Experiments\PV20130929B\20131004\PV20130929B_20131004_WM_1.txt'
behavIDName ='selfgroomingMale'; % 'mountingMale';
timeRange_ObserverFrames = [1500 200000];%[1500 18000]; % inclusive: >= timeRange_samples(1) and <=timeRange_samples(2) - corresponds to "between"  in ConvertIndicesToChronuxFormat.m
selfGroomingThresh = 1; % seconds. This serves as a minimum duration to compare the accuracy

behavIDOutputColumn = 1;
videonumOutputColumn = 2;
behavStartTimeFramesOutputColumn = 3;
behavStopTimeFramesOutputColumn = 4;
behavStartTimeSecondsOutputColumn = 5;
behavStopTimeSecondsOutputColumn = 6;
if ~isequal(behavStopTimeSecondsOutputColumn,(behavStartTimeSecondsOutputColumn+1))
    error('Stop time (seconds) column should be 1 greater than start time (seconds) column')
end

behavIDHeaderName = 'BehavID';
VideonumHeaderName = 'VideoNum';
videoAcq = 'tdt';
behavStartTimeHeaderName_frames = 'BehavStart_frames';
behavStopTimeHeaderName_frames = 'BehavStop_frames';
behavStartTimeHeaderName_seconds = 'BehavStart_seconds';
behavStopTimeHeaderName_seconds = 'BehavStop_seconds';
behavonsetlocation = 6;
behavdurationlocation = 7;
genderlocation = 10;
behavnamelocation = 11;
startorstoplocation = 12;
startstr = 'Statestart';
stopstr = 'Statestop'; 

videoAcq = lower(videoAcq);
for Scorer = 1:2
    if isequal(Scorer,1);
        iterfilename = iterfilename_Scorer1;
    elseif isequal(Scorer,2);
        iterfilename = iterfilename_Scorer2;
    end
    behavCellComplete ={};
    % Create headers
    behavCellComplete{1,behavIDOutputColumn}=behavIDHeaderName;
    behavCellComplete{1,videonumOutputColumn}=VideonumHeaderName;
    behavCellComplete{1,behavStartTimeFramesOutputColumn}=behavStartTimeHeaderName_frames;
    behavCellComplete{1,behavStopTimeFramesOutputColumn}=behavStopTimeHeaderName_frames;
    behavCellComplete{1,behavStartTimeSecondsOutputColumn}=behavStartTimeHeaderName_seconds;
    behavCellComplete{1,behavStopTimeSecondsOutputColumn}=behavStopTimeHeaderName_seconds;

    
    videonum = 1;

    fid=fopen(iterfilename,'r'); % read in Observer .txt file
    Observerdatastr = fscanf(fid,'%s',inf);
    fclose(fid);
    markers = find(Observerdatastr=='"');
    linebreaks = [];
    for j=1:(numel(markers)-1) % identify locations of line breaks
        markersID = markers(j);
        if Observerdatastr(markersID+1)==0 && Observerdatastr(markersID+2)==0 && Observerdatastr(markersID+3)==0 && Observerdatastr(markersID+4)=='"';
            linebreaks = [linebreaks markersID];
        end
    end

    behavCell={};
    
    count = 1;
    for k=1:numel(linebreaks); 
        if k<numel(linebreaks)
            markersinline = markers(markers>linebreaks(k) & markers<=linebreaks(k+1));
        else
            markersinline = markers(markers>linebreaks(k) & markers<=numel(Observerdatastr));
        end
        startorstopraw = Observerdatastr((markersinline(startorstoplocation*2-1)+1):(markersinline(startorstoplocation*2)-1));
        startorstopstr = startorstopraw(startorstopraw~=0);
        behavnameraw=Observerdatastr((markersinline(behavnamelocation*2-1)+1):(markersinline(behavnamelocation*2)-1));
        behavID = behavnameraw(behavnameraw~=0);
        genderraw = Observerdatastr((markersinline(genderlocation*2-1)+1):(markersinline(genderlocation*2)-1));
        gender = genderraw(genderraw~=0);
        behavID = [behavID gender];


        if strcmp(startorstopstr,startstr) && ~strcmpi(behavID(1:5),'event') && isequal(behavID,behavIDName);
            
            
            behavstarttimeraw_seconds = Observerdatastr((markersinline(behavonsetlocation*2-1)+1):(markersinline(behavonsetlocation*2)-1));
            behavdurationraw_seconds = Observerdatastr((markersinline(behavdurationlocation*2-1)+1):(markersinline(behavdurationlocation*2)-1));
            behavstarttime_seconds = str2double(behavstarttimeraw_seconds(behavstarttimeraw_seconds~=0)); 
            behavduration_seconds = str2double(behavdurationraw_seconds(behavdurationraw_seconds~=0));
            behavendtime_seconds = behavstarttime_seconds+behavduration_seconds; % same as in CreateBehaviorTemplate.m
            
            switch videoAcq
                case 'cleversys'
                    secondsmultipliertoframes = 29.9706282; % from CreateBehaviorTemplate.m
                case 'tdt'
                    secondsmultipliertoframes = 30.00031;
            end
            behavstarttime_frames = round(behavstarttime_seconds*secondsmultipliertoframes);
            behavendtime_frames = round(behavendtime_seconds*secondsmultipliertoframes);
            if behavstarttime_frames>=timeRange_ObserverFrames(1) && behavendtime_frames<=timeRange_ObserverFrames(2) 
                behavCell{count,behavIDOutputColumn}=behavID;
                behavCell{count,videonumOutputColumn}=videonum;
                behavCell{count,behavStartTimeSecondsOutputColumn}=behavstarttime_seconds;
                behavCell{count,behavStopTimeSecondsOutputColumn}=behavendtime_seconds;           
                behavCell{count,behavStartTimeFramesOutputColumn}=behavstarttime_frames;
                behavCell{count,behavStopTimeFramesOutputColumn}=behavendtime_frames;
                count=count+1;
            end

        end
    end
    behavCellComplete = [behavCellComplete; behavCell];  
    

    behavMat = cell2mat(behavCell(:,behavStartTimeSecondsOutputColumn:behavStopTimeSecondsOutputColumn));
    behavMatFrames = cell2mat(behavCell(:,behavStartTimeFramesOutputColumn:behavStopTimeFramesOutputColumn));

    % add in duration cut off to exclude short epoches in this analysis
    % JK edit 12/11/18
    duration = diff(behavMat,1,2);
    shortBehaviorEpochesToBeRemoved = duration <= selfGroomingThresh;
    behavMat_all = behavMat;
    behavMatFrames_all = behavMatFrames;
    behavMat = behavMat(~shortBehaviorEpochesToBeRemoved,:);
    behavMatFrames = behavMatFrames(~shortBehaviorEpochesToBeRemoved,:);
    
    % Convert to ms
    behavMat_ms = round(behavMat.*1000);
    behavMat_long = [];
    for i=1:size(behavMat_ms,1)
        behavMat_long = [behavMat_long, behavMat_ms(i,1):1:behavMat_ms(i,2)];
    end
    
    % 
    behavmat_long_Frames = [];
    for i=1:size(behavMatFrames,1)
        behavmat_long_Frames = [behavmat_long_Frames, behavMatFrames(i,1):1:behavMatFrames(i,2)];
    end
    
    if isequal(Scorer,1)
        scorer1Mat = behavMat_long;
        scorer1MatFrames = behavmat_long_Frames;
    elseif isequal(Scorer,2)
        scorer2Mat = behavMat_long;
        scorer2MatFrames = behavmat_long_Frames;
    end
end

%% Separate analysis by LA 5/23/16
% for each subject, create matrix of 1s and 0s where behavior occurring
% indicated as 1 (frames)
baseMatScorer1 = zeros(1,numel(timeRange_ObserverFrames(1):timeRange_ObserverFrames(2)));
baseMatScorer2 = zeros(1,numel(timeRange_ObserverFrames(1):timeRange_ObserverFrames(2)));
for i=1:numel(scorer1MatFrames)
    scorer1MatFramesi = scorer1MatFrames(i);
    scorer1MatFramesiAdj = scorer1MatFramesi-timeRange_ObserverFrames(1)+1;
    baseMatScorer1(scorer1MatFramesiAdj)=1;
end

for i=1:numel(scorer2MatFrames)
    scorer2MatFramesi = scorer2MatFrames(i);
    scorer2MatFramesiAdj = scorer2MatFramesi-timeRange_ObserverFrames(1)+1;
    baseMatScorer2(scorer2MatFramesiAdj)=1;
end

if ~isequal(numel(baseMatScorer1),numel(baseMatScorer2))
    error('Unexpected difference in size of baseMatScorer between scorers')
end

diffBaseMat = baseMatScorer1 - baseMatScorer2;
diffBaseMatEqualZeroIDs = find(diffBaseMat==0);
percentConsistentScoring = (numel(diffBaseMatEqualZeroIDs)/numel(baseMatScorer1))*100;

%%
[intersectMat,id1,id2] = intersect(scorer1Mat,scorer2Mat);

scorer1MatNotIntersect = scorer1Mat;
scorer1MatNotIntersect(id1)=[]; 
scorer2MatNotIntersect = scorer2Mat;
scorer2MatNotIntersect(id2)=[];

% Confirm that intersect and not intersect together make the original
Test1 = [scorer1MatNotIntersect intersectMat];
Test1 = sort(Test1);
Test2 = [scorer2MatNotIntersect intersectMat];
Test2 = sort(Test2);
if ~isequal(Test1,scorer1Mat) || ~isequal(Test2, scorer2Mat)
    error('intersection and non-intersection points together do not make the original')
end

%%
finalTimeScorer1 = scorer1Mat(end); % in ms
finalTimeScorer2 = scorer2Mat(end); % in ms
initialTimeScorer1 = scorer1Mat(1);
initialTimeScorer2 = scorer2Mat(1);
finalTime = max([finalTimeScorer1 finalTimeScorer2]);
initialTime = min([initialTimeScorer1 initialTimeScorer2]);
range = finalTime;


scorer1Dot = zeros(1,numel(1:1:range)); 
scorer2Dot = zeros(1,numel(1:1:range));
intersectDot = zeros(1,numel(1:1:range));
notIntersectDot1 =zeros(1,numel(1:1:range));
notIntersectDot2 =zeros(1,numel(1:1:range));

for i=1:numel(scorer1Mat)
    score1 = round(scorer1Mat(i));
    scorer1Dot(score1)=0.9;
end

for i=1:numel(scorer2Mat)
    score2 = round(scorer2Mat(i));
    scorer2Dot(score2)=0.7;
end

for i=1:numel(intersectMat)
    intersect12 = round(intersectMat(i));
    intersectDot(intersect12)=0.5;
end

for i=1:numel(scorer1MatNotIntersect)
    notIntersect1 = round(scorer1MatNotIntersect(i));
    notIntersectDot1(notIntersect1)=0.3;
end

for i=1:numel(scorer2MatNotIntersect)
    notIntersect2 = round(scorer2MatNotIntersect(i));
    notIntersectDot2(notIntersect2)=0.1;
end

xaxisScaledMin = (1:1:range)/1000/60;
figure;plot(xaxisScaledMin,scorer1Dot,'.','markersize',0.5)
set(gca,'YTickLabel',[])
ylim([0 1])
xlim([initialTime/1000/60-15 finalTime/1000/60+15])
xlabel('Time (min)')
hold on
plot(xaxisScaledMin,scorer2Dot,'r.','markersize',0.5)
plot(xaxisScaledMin,intersectDot,'g.','markersize',0.5)
plot(xaxisScaledMin,notIntersectDot1,'k.','markersize',0.5)
plot(xaxisScaledMin,notIntersectDot2,'k.','markersize',0.5)

%%
percentIntersection1 = numel(intersectMat)/numel(scorer1Mat)*100; % how well Scorer 2 captures Score 1 record
percentIntersection2 = numel(intersectMat)/numel(scorer2Mat)*100; % how well Scorer 1 captures Scorer 2 record

display([num2str(percentIntersection1),'% agreement with Scorer 1; ',num2str(percentIntersection2),'% agreement with Scorer 2'])
            
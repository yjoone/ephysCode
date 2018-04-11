function CreateBehaviorTemplate(behavtemplatefilename,recdstruct,maptoiterationspruned_cell,filepathtobehavior,varargin)
behavIDOutputColumn = 1;
videonumOutputColumn = 2;
behavStartTimeFramesOutputColumn = 3;
behavStopTimeFramesOutputColumn = 4;
behavStartTimeSecondsOutputColumn = 5;
behavStopTimeSecondsOutputColumn = 6;
scoringSoftwareColumn = 7;
saveColumnInfoFilename = 'BehaviorTemplateKey.mat';

behavIDHeaderName = 'BehavID';
VideonumHeaderName = 'VideoNum';
behavStartTimeHeaderName_frames = 'BehavStart_frames';
behavStopTimeHeaderName_frames = 'BehavStop_frames';
behavStartTimeHeaderName_seconds = 'BehavStart_seconds';
behavStopTimeHeaderName_seconds = 'BehavStop_seconds';
scoringSoftware = 'ScoringSoftware';
assign(varargin{:});

keyFilename = fullfile(filepathtobehavior,saveColumnInfoFilename);
if exist(keyFilename) 
    delete(keyFilename)
end
save(keyFilename,'behavIDOutputColumn','videonumOutputColumn','behavStartTimeFramesOutputColumn','behavStopTimeFramesOutputColumn','behavStartTimeSecondsOutputColumn','behavStopTimeSecondsOutputColumn','scoringSoftwareColumn');

% first row are headers
behavCellComplete ={};
behavCellComplete{1,behavIDOutputColumn}=behavIDHeaderName;
behavCellComplete{1,videonumOutputColumn}=VideonumHeaderName;
behavCellComplete{1,behavStartTimeFramesOutputColumn}=behavStartTimeHeaderName_frames;
behavCellComplete{1,behavStopTimeFramesOutputColumn}=behavStopTimeHeaderName_frames;
behavCellComplete{1,behavStartTimeSecondsOutputColumn}=behavStartTimeHeaderName_seconds;
behavCellComplete{1,behavStopTimeSecondsOutputColumn}=behavStopTimeHeaderName_seconds;
behavCellComplete{1,scoringSoftwareColumn}=scoringSoftware;

for i=1:numel(maptoiterationspruned_cell) % can have multiple behaviors and/or multiple video files for a given behavior. Note: only one iteration for each behavior because have pruned for this (only take iteration file with specific filename extension)
    map = maptoiterationspruned_cell{i};
    videonum = recdstruct.Behav(map(1)).VideoNum;
    videoacq = recdstruct.Behav(map(1)).VideoAcq;
    behavIDName = recdstruct.Behav(map(1)).BehavIDName;
    behavsoftware = recdstruct.Behav(map(1)).Iterations(map(2)).BehavSoftware;
    iterfilename = fullfile(filepathtobehavior,[recdstruct.Behav(map(1)).Iterations(map(2)).Iterfilename,'.',recdstruct.Behav(map(1)).Iterations(map(2)).IterfileExt]);
    switch behavsoftware
        case 'Observer' %iteration file is a .txt file in comma delimited format
            behavonsetlocation = 6; % comma delimiter locations
            behavdurationlocation = 7;
            genderlocation = 10;
            behavnamelocation = 11;
            startorstoplocation = 12;
            startstr = 'Statestart';
            stopstr = 'Statestop';
            
            fid=fopen(iterfilename,'r');
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
            count = 0;
            
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
                    count=count+1;
                    behavstarttimeraw_seconds = Observerdatastr((markersinline(behavonsetlocation*2-1)+1):(markersinline(behavonsetlocation*2)-1));
                    behavdurationraw_seconds = Observerdatastr((markersinline(behavdurationlocation*2-1)+1):(markersinline(behavdurationlocation*2)-1));
                    behavstarttime_seconds = str2double(behavstarttimeraw_seconds(behavstarttimeraw_seconds~=0)); 
                    behavduration_seconds = str2double(behavdurationraw_seconds(behavdurationraw_seconds~=0));
                    behavendtime_seconds = behavstarttime_seconds+behavduration_seconds;
                    behavCell{count,behavIDOutputColumn}=behavID;
                    behavCell{count,videonumOutputColumn}=videonum;
                    behavCell{count,behavStartTimeSecondsOutputColumn}=behavstarttime_seconds;
                    behavCell{count,behavStopTimeSecondsOutputColumn}=behavendtime_seconds;
                    
                    switch videoacq
                        case 'Cleversys'
                            secondsmultipliertoframes = 29.9706282; % if change, need to update in CreateTimestampLog.m and Reliability_Analysis_Development.m 
                        case 'TDT'
                            secondsmultipliertoframes = 30.00031; % if change, need to update in Reliability_Analysis_Development.m
                    end
                    % check goodness of multiplier
                    diffStartTimesRound = abs((behavstarttime_seconds*secondsmultipliertoframes)-round(behavstarttime_seconds*secondsmultipliertoframes));
                    diffEndTimesRound = abs((behavendtime_seconds*secondsmultipliertoframes)-round(behavendtime_seconds*secondsmultipliertoframes));
                    if ~isempty(find(diffStartTimesRound>0.1,1)) || ~isempty(find(diffEndTimesRound>0.1,1))
                        display('Warning: check conversion from seconds to frames for the following times (seconds):')
                        behavStartTimeCheck = behavstarttime_seconds(find(diffStartTimesRound>0.1))
                        behavEndTimeCheck = behavendtime_seconds(find(diffEndTimesRound>0.1))
                    end
                    
                    behavCell{count,behavStartTimeFramesOutputColumn}=round(behavstarttime_seconds*secondsmultipliertoframes);
                    behavCell{count,behavStopTimeFramesOutputColumn}=round(behavendtime_seconds*secondsmultipliertoframes);
                    behavCell{count,scoringSoftwareColumn}= 'Observer'; % added EA 4/29/14
                    
                end
            end
            behavCellComplete = [behavCellComplete; behavCell];
    end 
end
xlswrite(behavtemplatefilename,behavCellComplete);



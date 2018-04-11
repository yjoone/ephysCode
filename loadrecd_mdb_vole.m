function [varargout] = loadrecd_mdb_vole(recdstruct,mdb,exptDatadir,varargin)

% FUNCTION [VARARGOUT] = LOADRECD_MDB(RECDSTRUCT,MDB,VARARGIN)
loadinbehavifexists = true;
wantDecimateData = true;
decimateFactor = 32;
wantCreateBehavTemplate = true;
assign(varargin{:});

% Get animal's expt and animal info
exptstruct = mdb.expt(matchindex(mdb.loc(matchindex([recdstruct(1).LocID],[mdb.loc.LocID])).ExptID,...
    [mdb.expt.ExptID]));
% Also need the Animal's DataFolder
animstruct = mdb.anim(logical(ismember({mdb.anim.Animal},exptstruct.Animal)));

outparam = 1;
switch lower(recdstruct(1).Software)
    case 'tdt'
        % get class of expt session folder
        exptSessionName = exptstruct.ExptDate;
        classExptSession = class(exptSessionName);
        if isequal(classExptSession,'double')
            exptSessionPathname = num2str(exptSessionName);
        elseif isequal(classExptSession,'char')
            exptSessionPathname = exptSessionName;
        else
            error('experiment session name is unexpected class')
        end
                
        pathname = fullfile(exptDatadir,...  % Experiment folder
            animstruct.DataFolder,...
            exptSessionPathname);
         
        
        % collect location ids
        locs = zeros(1,numel(recdstruct));
        for i=1:numel(recdstruct)
            locs(i)=recdstruct(i).LocID;
        end
        % verify unique location ids (each recdstruct(i) corresponds to its
        % own location
        for i=1:numel(locs)
            locsi=locs(i);
            locsRemaining=locs(~ismember(1:numel(locs),i));
            if isequal(ismember(locsi,locsRemaining),1)
                error('Redundant locations')
            end
        end
        
        outparam=1;
        varargout{outparam}.animal = exptstruct.Animal;
        varargout{outparam}.exptdate = exptstruct.ExptDate;
        varargout{outparam}.locids = locs; 
         
        
        % store neural data for each location
        signalStruct = struct;
        for i=1:numel(locs)
            dataFileCheckField = recdstruct(i).Filestr;
            
            % load in appropriate version of channel data
            if wantDecimateData==true
                samplerateLoad = (recdstruct(1).Samplerate)/decimateFactor;
                dataFile = fullfile(pathname,[recdstruct(i).Filestr,'dc',num2str(decimateFactor),'.',recdstruct(i).Ext]);
                if ~exist(dataFile,'file')
                    display('decimating channel data')
                    
                    % load in original data
                    dataFileOrig = fullfile(pathname,[recdstruct(i).Filestr,'.',recdstruct(i).Ext]);
                    loadedSignal = load(dataFileOrig);
                    
                    % check fieldname matches filename
                    fieldnamesLoadedSignal = fieldnames(loadedSignal);
                    if numel(fieldnamesLoadedSignal)>1
                        error('Expected only one channel name in loaded file')
                    end
                    locationsunderscoreN = strfind(dataFileCheckField,'_');
                    locationunderscoreChan = locationsunderscoreN(end);
                    chan_string = dataFileCheckField((locationunderscoreChan+1):end);
                    if ~strcmp(chan_string,fieldnamesLoadedSignal{1})
                        error('channel field name must match filename')
                    end
                    
                    % check if row or column vector
                    loadedSignalVar = loadedSignal.(fieldnamesLoadedSignal{1});
                    sizeLoadedSignal = size(loadedSignalVar);
                    if ~isequal(numel(sizeLoadedSignal),2)
                        error('Unexpected: size loadedSignal should be 2')
                    end
                    findSingularDimLoadedSignal = find(sizeLoadedSignal==1);
                    if isempty(findSingularDimLoadedSignal)
                        error('Unexpected: one dimension in loadedSignal should have a size of 1')
                    end
                    if numel(findSingularDimLoadedSignal)>1
                        error('Unexpected: only 1 dimension in loadedSignal should have size of 1')
                    end            
                    if isequal(findSingularDimLoadedSignal,2) % column format; convert to row
                        loadedSignalVarRow1 = loadedSignalVar';  
                    elseif isequal(findSingularDimLoadedSignal,1)
                        loadedSignalVarRow1 = loadedSignalVar;
                    end
                    
                    loadedSignalVarRow1 = double(loadedSignalVarRow1); % convert from single to double point precision
                    
                    % decimate
                    % check if decimate factor is greater than 13. If so,
                    % split into multiple decimations (see Matlab
                    % documentation of decimate); for ease of use with
                    % large decimation factor: set decimation factor as a
                    % power of 2; algorith verified by LA 4/14/17
                    if decimateFactor>13 
                        decimatePower = log2(decimateFactor);
                        if ~isequal(decimatePower,round(decimatePower))
                            error('large decimation factor should be a power of 2 for ease of use')
                        else
                            loadedSignalVarRowdc = loadedSignalVarRow1;
                            downsampledIndices_pdcCell = cell(1,decimatePower);
                            for pdc=1:decimatePower
                                [loadedSignalVarRowdc,downsampledIndices_pdc] = DecimateUsingIIRFilterAndReportIndices(loadedSignalVarRowdc,2);
                                downsampledIndices_pdcCell{pdc}=downsampledIndices_pdc;
                            end
                            downsampledIndices_pdcCellFirst = downsampledIndices_pdcCell{1};
                            downsampledIndices_pdcCellLast = downsampledIndices_pdcCell{end}; 

                            downsampledIndices = zeros(1,numel(downsampledIndices_pdcCellLast));
                            for v=1:numel(downsampledIndices_pdcCellLast)
                                downsampledIndices_pdcCellEndv = downsampledIndices_pdcCellLast(v);
                                

                                if decimatePower>=3
                                    % loop through previous decimations
                                    indexPrev = downsampledIndices_pdcCellEndv;
                                    for prevDecimation = (decimatePower-1):-1:2;
                                        prevDecimationIndices = downsampledIndices_pdcCell{prevDecimation};
                                        indexPrev = prevDecimationIndices(indexPrev);
                                    end
                                elseif decimatePower==2
                                    error('unexpected number of decimations')
                                    %indexPrev = downsampledIndices_pdcCellEndv;
                                else
                                    error('unexpected number of decimations')
                                end
                                
                                downsampledIndices(v) = downsampledIndices_pdcCellFirst(indexPrev);
                            end
                        end
                    else
                        [loadedSignalVarRowdc,downsampledIndices] = DecimateUsingIIRFilterAndReportIndices(loadedSignalVarRow1,decimateFactor);
                    end
                                        
                    % save
                    dcStruct = struct;
                    dcStruct.(fieldnamesLoadedSignal{1}) = loadedSignalVarRowdc;
                    save(dataFile,'dcStruct');
                    
                    loadedSignalVarRow = loadedSignalVarRowdc;
                else
                    display('decimated channel data found')
                    loadedSignalStruct = load(dataFile);
                    loadedSignal = loadedSignalStruct.dcStruct;
                    
                    % check fieldname matches filename
                    fieldnamesLoadedSignal = fieldnames(loadedSignal);
                    if numel(fieldnamesLoadedSignal)>1
                        error('Expected only one channel name in loaded file')
                    end
                    locationsunderscoreN = strfind(dataFileCheckField,'_');
                    locationunderscoreChan = locationsunderscoreN(end);
                    chan_string = dataFileCheckField((locationunderscoreChan+1):end);
                    if ~strcmp(chan_string,fieldnamesLoadedSignal{1})
                        error('channel field name must match filename')
                    end
                    
                    % check if row or column vector
                    loadedSignalVar = loadedSignal.(fieldnamesLoadedSignal{1});
                    sizeLoadedSignal = size(loadedSignalVar);
                    if ~isequal(numel(sizeLoadedSignal),2)
                        error('Unexpected: size loadedSignal should be 2')
                    end
                    findSingularDimLoadedSignal = find(sizeLoadedSignal==1);
                    if isempty(findSingularDimLoadedSignal)
                        error('Unexpected: one dimension in loadedSignal should have a size of 1')
                    end
                    if numel(findSingularDimLoadedSignal)>1
                        error('Unexpected: only 1 dimension in loadedSignal should have size of 1')
                    end            
                    if isequal(findSingularDimLoadedSignal,2) % column format; convert to row
                        loadedSignalVarRow = loadedSignalVar'; 
                    elseif isequal(findSingularDimLoadedSignal,1)
                        loadedSignalVarRow = loadedSignalVar;
                    end
                    loadedSignalVarRow = double(loadedSignalVarRow); % convert from single to double format if not already in double
                end
            else
                samplerateLoad = recdstruct(1).Samplerate;
                dataFile = fullfile(pathname,[recdstruct(i).Filestr,'.',recdstruct(i).Ext]);
                loadedSignal = load(dataFile);
                
                % check fieldname matches filename
                fieldnamesLoadedSignal = fieldnames(loadedSignal);
                if numel(fieldnamesLoadedSignal)>1
                    error('Expected only one channel name in loaded file')
                end
                locationsunderscoreN = strfind(dataFileCheckField,'_');
                locationunderscoreChan = locationsunderscoreN(end);
                chan_string = dataFileCheckField((locationunderscoreChan+1):end);
                if ~strcmp(chan_string,fieldnamesLoadedSignal{1})
                    error('channel field name must match filename')
                end

                % check if row or column vector
                loadedSignalVar = loadedSignal.(fieldnamesLoadedSignal{1});
                sizeLoadedSignal = size(loadedSignalVar);
                if ~isequal(numel(sizeLoadedSignal),2)
                    error('Unexpected: size loadedSignal should be 2')
                end
                findSingularDimLoadedSignal = find(sizeLoadedSignal==1);
                if isempty(findSingularDimLoadedSignal)
                    error('Unexpected: one dimension in loadedSignal should have a size of 1')
                end
                if numel(findSingularDimLoadedSignal)>1
                    error('Unexpected: only 1 dimension in loadedSignal should have size of 1')
                end            
                if isequal(findSingularDimLoadedSignal,2) % column format; convert to row
                    loadedSignalVarRow = loadedSignalVar'; 
                elseif isequal(findSingularDimLoadedSignal,1)
                    loadedSignalVarRow = loadedSignalVar;
                end
                loadedSignalVarRow = double(loadedSignalVarRow); % convert from single to double precision
            end
                                
            signalStruct.(fieldnamesLoadedSignal{1}) = loadedSignalVarRow;
        end
        varargout{outparam}.signal = signalStruct;
        varargout{outparam}.samplerate = samplerateLoad;
        
% LA note Feb 16, 2017 need to adapt nl section to have multiple locIDs in same struct (see TDT above)         
%     case 'nl' % Added by EA Spring 2013
%         pathname = fullfile(exptDatadir,...  % Experiment folder
%             animstruct.DataFolder,...
%             int2str(exptstruct.ExptDate));
%         wantremoveartifactsNL=true;
%         shiftneuraldata=-127.5; % Neural data originally ranges from 0 to 255; shift to center around 0 (-127.5 to 127.5)
%         removeartifactscellNL={}; % A cell array of strings, each string indicates type of artifact removal want to do. "rp": remove repeated peaks
%         wantCreateBehavTemplateNL = true; % Set to false if have multiple neural channels for a given animal, but behavior file is the same across channels. Only need to make the behavior template once when loading in the first channel
%         assign(varargin{:});
%         
%         outparam=1;
%         varargout{outparam}.animal = exptstruct.Animal; % Populate fields in output -- use same format as for case 'bw' in lab's loadrecd function
%         varargout{outparam}.exptdate = exptstruct.ExptDate;
%         varargout{outparam}.locid = recdstruct.LocID;
%         varargout{outparam}.trials.timestamp=NaN;
%         varargout{outparam}.trials.SGI=NaN;
%         varargout{outparam}.trials.stimparams=NaN;
%         
%         binaryfilenames ={'chan1','chan2','chan3','chan4'}; % Setting up to save NL channels as binary files -- once these files are made, much faster to load in data for analysis compared to original .hex format   
%         channel=recdstruct.Channel; % channel number
%         chanbinaryfilename = fullfile(pathname,[binaryfilenames{channel},'.bin']);
%         IRbinaryfilename = fullfile(pathname,'IR.bin');
%         movebinaryfilename = fullfile(pathname,'move.bin');
%         
%         if ~exist(chanbinaryfilename,'file') % if binary file for a given channel doesn't exist, need to make one.
%             nlfilename = fullfile(pathname,[recdstruct.Filestr,'.hex']);
%             [datacell,samplerate]=readNL(nlfilename);
%             alldata = LoaddatabulkNL(datacell,'bufferVal',-round(shiftneuraldata)); % LoaddatabulkNL loads in all of the channels; use round because data will be stored as 8 bit and numbers need to be in integers
%             neuraldataunshifted = alldata(channel+2,:); %first two rows are refs 1 and 2
%             fid = fopen(chanbinaryfilename, 'w');
%             fwrite(fid, neuraldataunshifted, 'uint8'); % data is 8bit
%             fclose(fid);
%         else
%             fid = fopen(chanbinaryfilename); % if binary file exists, load it in.
%             neuraldataunshifted = fread(fid,inf,'uint8=>double'); % convert data to double floating point so that can shift range from 0to255 to -127.5to127.5;
%             fclose(fid);
%             neuraldataunshifted=neuraldataunshifted'; % convert to a row
%         end
%         
%         % same idea as above for infrared (IR) data
%         if ~exist(IRbinaryfilename,'file')
%             if ~exist('alldata','var')
%                 nlfilename = fullfile(pathname,[recdstruct.Filestr,'.hex']);
%                 [datacell,samplerate]=readNL(nlfilename);
%                 alldata = LoaddatabulkNL(datacell); % LoaddatabulkNL loads in all of the channels
%             end 
%             IRdata = alldata(7,:); 
%             fid = fopen(IRbinaryfilename, 'w');
%             fwrite(fid, IRdata, 'uint8');
%             fclose(fid);
%         else
%             fid = fopen(IRbinaryfilename);
%             IRdata = fread(fid,inf,'uint8=>double');
%             fclose(fid);
%             IRdata=IRdata';
%         end
%         
%         % same for movement (move) data -- Added Jan 2014, EA
%         if ~exist(movebinaryfilename,'file')
%             if ~exist('alldata','var')
%                 nlfilename = fullfile(pathname,[recdstruct.Filestr,'.hex']);
%                 [datacell,samplerate]=readNL(nlfilename);
%                 alldata = LoaddatabulkNL(datacell); % LoaddatabulkNL loads in all of the channels
%             end 
%             movedata = alldata(8,:); 
%             fid = fopen(movebinaryfilename, 'w');
%             fwrite(fid, movedata, 'uint8');
%             fclose(fid);
%         else
%             fid = fopen(movebinaryfilename);
%             movedata = fread(fid,inf,'uint8=>double');
%             fclose(fid);
%             movedata=movedata';
%         end
%         
%         movedataNonZeroIfMove = abs(diff(movedata)); % non-zero if there is a change in value between samples, indicating movement (see NL manual)
%         
%         % Artifact Removal
%         if isempty(removeartifactscellNL) % removeartifactscellNL is a cell array of strings, each string indicates type of artifact removal want to do (see above); if do not include this as an input, will use the regular [channel].bin file
%             loadformat = 'bin_noartifactremoval';
%         else
%             removeartifactsNLext = '';
%             for m=1:(numel(removeartifactscellNL)) % for each type of artifact removal in removeartifactscellNL
%                 removeartifactsNLext = strcat(removeartifactsNLext,'_',removeartifactscellNL{m}); % file extension for new bin file of a channel with artifacts removed
%             end
%             artifactremovalfilename = fullfile(pathname,[binaryfilenames{channel},removeartifactsNLext,'.bin']); % same filename as above, except now has ending indicating type(s) of artifacts removed
%             if ~exist(artifactremovalfilename,'file') % if binary file for a given channel with artifacts removed does not exist, need to make one.
%                 disp('No version with artifacts removed');
%                 if wantremoveartifactsNL % only make the file if wantremoveartifactsNL is set to "true"
%                     disp('*** Removing artifacts and saving new version');
%                     neuraldatashifted = neuraldataunshifted+shiftneuraldata;
%                     lfpoutNL = removeartifactsNL_mdb(neuraldatashifted,removeartifactscellNL);
%                     fid = fopen(artifactremovalfilename, 'w');
%                     fwrite(fid, lfpoutNL, 'double');
%                     fclose(fid);
%                     loadformat = 'bin_artifactremoval';
%                 else
%                     loadformat = 'bin_noartifactremoval';
%                 end
%             else
%                 disp('Version with artifacts removed found'); % if binary file exists, load it in
%                 fid = fopen(artifactremovalfilename);
%                 lfpoutNL = fread(fid,inf,'double');
%                 fclose(fid);
%                 lfpoutNL=lfpoutNL';
%                 loadformat = 'bin_artifactremoval';
%             end
%         end
% 
%         varargout{outparam}.trials.timestamp = NaN;
%         varargout{outparam}.trials.SGI = NaN;
%         varargout{outparam}.trials.stimparams = NaN;
% 
%         switch loadformat
%             case 'bin_noartifactremoval',
%                 varargout{outparam}.trials.signal = neuraldataunshifted+shiftneuraldata;
%                 varargout{outparam}.removedartifacts = false;
%             case 'bin_artifactremoval',
%                 varargout{outparam}.trials.signal = lfpoutNL;
%                 varargout{outparam}.removedartifacts = true;
%         end
%         
%         varargout{outparam}.trials.movement = movedataNonZeroIfMove; 
%         
    otherwise
        % Non-brainware file
        pathname = exptDatadir;
        filename = '';
        resp = [];
        respDAM = [];
end


if isfield(recdstruct(1),'Behav')
    if loadinbehavifexists
        switch lower(recdstruct(1).Software)
            case 'tdt'
                completeListBehaviors = {};
                for z=1:numel(recdstruct(1).Behav) % corresponds to number of behaviors
                    completeListBehaviors = [completeListBehaviors recdstruct(1).Behav(z).BehavIDName];
                end
                
                behavfilenumchoose = 1; % by default, will choose behavior scoring file ('iteration') that has a '_1' at the end of the filename
                
                count=0;
                behavfilenames_cell={};
                pathtoiterations_cell={};
                for i=1:numel(recdstruct(1).Behav) % Can have multiple behavior/videoNum/Duration/VideoAcq combinations for a given animal
                    behavStruct=recdstruct(1).Behav(i);
                    for j=1:numel(behavStruct.Iterations) % Can have multiple iterations within this
                        behavfilename = recdstruct(1).Behav(i).Iterations(j).Iterfilename; 
                        count=count+1;
                        behavfilenames_cell{count}=behavfilename;
                        pathtoiterations_cell{count}=[i,j]; % roadmap through recdstruct to get to iterations
                    end
                end
                
                % prune results to iterations with 'behavefilenumchoose' at
                % end of filename
                countagain=0;
                behavfilenamespruned_cell={};
                maptoiterationspruned_cell={};
                for k=1:numel(behavfilenames_cell)
                    testfilename=behavfilenames_cell{k};
                    locationsunderscore = strfind(testfilename,'_');
                    locationunderscorevideonum = locationsunderscore(end);
                    filenum_string = testfilename((locationunderscorevideonum+1):end); % iteration must be in format '[something]_[filenumber]' Assume filenum occurs after last underscore (if there are multiple underscores in filename)
                    if strcmp(filenum_string,num2str(behavfilenumchoose))
                        countagain = countagain+1;
                        behavfilenamespruned_cell{countagain} = testfilename;
                        maptoiterationspruned_cell{countagain}=pathtoiterations_cell{k};
                    end
                end
                
                
                if ~countagain
                    error('No file with the specified number at the end of the filename');
                end
                
                % iteration needs to be in a template format; if template file doesn't exist, need to make
                % one 

                behavtemplatefilename = fullfile(pathname,[animstruct.DataFolder,'_',exptSessionPathname,'_behavtemplate.xlsx']);
                if isequal(wantCreateBehavTemplate,true)
                    if exist(behavtemplatefilename,'file')
                        delete(behavtemplatefilename)
                    end
                    CreateBehaviorTemplate(behavtemplatefilename,recdstruct(1),maptoiterationspruned_cell,pathname);
                    display('Creating new behavior file in template format')
                end
                                
                behavfilename = behavtemplatefilename;

                % read in iteration in template format
                [Num,Txt,Raw] = xlsread(behavfilename);
                
                load(fullfile(pathname,'BehaviorTemplateKey.mat'));
                

                headercolumn = Txt(2:end,behavIDOutputColumn); % headercolumn refers to the BehavIDs (e.g. 'huddlingFemale') in the template file; behavIDOutputColumn is from behavTemplateKey;first entry is 'BehavID' so start index at 2
                [sortedHeaders,sortIndices]=sortrows(headercolumn); % sort rows by BehavID; 
                sortedUniqueHeaders = unique(sortedHeaders); % exclude repeated instances
                correspRaw = Raw(2:end,:);
                sortedRaw = correspRaw(sortIndices,:); % sort data (rows of behavior starts and stops) accordingly
                
                softwareColumn = Txt(2:end,scoringSoftwareColumn); % sort scoring software associated with each data row; added EA 4/29/14
                sortedSoftwareCell = softwareColumn(sortIndices,:);
                
                % load in nFrames to match frames to neural samples
                
                % first, verify that each behavior has same associated
                % FilestrMatchNeural
                testFilename = recdstruct(1).Behav(1).FilestrMatchNeural;
                for k=1:numel(recdstruct(1).Behav)
                    if ~isequal(recdstruct(1).Behav(k).FilestrMatchNeural,testFilename)
                        error('FilestrMatchNeural should be the same across scored behavior for given experiment x stimulus condition')
                    end
                end
                
                % load in regular or downsampled version of nFrames depending
                % on whether decimated neural channel data
                
                if wantDecimateData==true
                    filepathnFrame = fullfile(pathname,[recdstruct(1).Behav(1).FilestrMatchNeural,'dc',num2str(decimateFactor),'.',recdstruct(1).Ext]);
                    if ~exist(filepathnFrame,'file')
                        display('downsampling nFrame')
                        filepathnFrameOrig = fullfile(pathname,[recdstruct(1).Behav(1).FilestrMatchNeural,'.',recdstruct(1).Ext]);
                        nFramesStructOrig = load(filepathnFrameOrig);
                        nFramesVar = nFramesStructOrig.nFrame(downsampledIndices);
                        save(filepathnFrame,'nFramesVar');
                    else
                        display('downsampled nFrame found')
                        nFramesStructFull = load(filepathnFrame); 
                        nFramesVar = nFramesStructFull.nFramesVar;
                    end
                else
                    filepathnFrame = fullfile(pathname,[recdstruct(1).Behav(1).FilestrMatchNeural,'.',recdstruct(1).Ext]);
                    nFramesStruct = load(filepathnFrame); 
                    nFramesVar = nFramesStruct.nFrame;
                end
                
                % put in row format 
                nFramesVarSize = size(nFramesVar);
                
                if ~isequal(numel(nFramesVarSize),2)
                    error('Unexpected: size nFramesVar should be 2')
                end
                findSingularDimnFrames = find(nFramesVarSize==1);
                if isempty(findSingularDimnFrames)
                    error('Unexpected: one dimension in nFramesVar should have a size of 1')
                end
                if numel(findSingularDimnFrames)>1
                    error('Unexpected: only 1 dimension in nFramesVar should have size of 1')
                end
                if isequal(findSingularDimnFrames,2) % column format; convert to row
                    framesMatchNeural = nFramesVar'; 
                elseif isequal(findSingularDimnFrames,1)
                    framesMatchNeural = nFramesVar; 
                end
                framesMatchNeural = double(framesMatchNeural); % convert from single to double precision
                varargout{outparam}.nFrame = framesMatchNeural;
                
                % convert frames to neural samples
                sortedStartFrames = cell2mat(sortedRaw(:,behavStartTimeFramesOutputColumn));
                sortedStopFrames = cell2mat(sortedRaw(:,behavStopTimeFramesOutputColumn)); 
                if ~isequal(numel(sortedStartFrames),numel(sortedStopFrames))
                    error('numbers of start and last frames should match')
                end
                idsSamples = zeros(numel(sortedStartFrames),2);
                
                for m=1:size(idsSamples,1)
                    idFirstNeuralSampleAssocStartFrame = find(framesMatchNeural==sortedStartFrames(m),1); % find earliest neural sample associated with given frame
                    idsSamples(m,1)=idFirstNeuralSampleAssocStartFrame;
                    
                    idFirstNeuralSampleAssocStopFrame = find(framesMatchNeural==sortedStopFrames(m),1); % find earliest neural sample associated with given frame
                    idsSamples(m,2)=idFirstNeuralSampleAssocStopFrame-1; % last sample associated with previous frame (i.e. before behavior has stopped)
                end
                
                
                % organize epochs for each header into cell array of
                % matrices
                epochs = {};
                for i=1:numel(sortedUniqueHeaders)
                    epochs{i}=[];
                end
                currentheadernum = 1;
                for i=1:size(idsSamples,1)                       
                    epochtoadd = idsSamples(i,1):idsSamples(i,2); 
                    epochs{currentheadernum}=[epochs{currentheadernum} epochtoadd];
                    if i<size(idsSamples,1)
                        if ~strcmp(sortedHeaders(i+1,1),sortedUniqueHeaders{currentheadernum}) %sortedHeaders should be same length as behavSamples
                            currentheadernum = currentheadernum+1;
                        end
                    end
                end
                
                for i=1:numel(completeListBehaviors)
                    behaviori = completeListBehaviors{i};
                    if ~isempty(find(strcmp(sortedUniqueHeaders,behaviori),1))
                        index = find(strcmp(sortedUniqueHeaders,behaviori));
                        if numel(index)>1
                            error('multiple instances of behavior name')
                        end
                        headername = behaviori;
                        varargout{outparam}.neuralidsbehavs.(headername)=epochs{index}; 
                    else
                        headername = behaviori;
                        varargout{outparam}.neuralidsbehavs.(headername)=[];
                    end
                end
                
                


                
%             case 'nl'  
%                 completeListBehaviors = {};
%                 for z=1:numel(recdstruct.Behav) % corresponds to number of behaviors
%                     completeListBehaviors = [completeListBehaviors recdstruct.Behav(z).BehavIDName];
%                 end
%                       
%                 behavfilenumchoose = 1; % by default, will choose behavior scoring file ('iteration') that has a '_1' at the end of the filename
%                 
%                 count=0;
%                 behavfilenames_cell={};
%                 pathtoiterations_cell={};
%                 for i=1:numel(recdstruct.Behav) % Can have multiple behavior/videoNum/Duration/VideoAcq combinations for a given animal
%                     behavStruct=recdstruct.Behav(i);
%                     for j=1:numel(behavStruct.Iterations) % Can have multiple iterations within this
%                         behavfilename = recdstruct.Behav(i).Iterations(j).Iterfilename; 
%                         count=count+1;
%                         behavfilenames_cell{count}=behavfilename;
%                         pathtoiterations_cell{count}=[i,j]; % roadmap through recdstruct to get to iterations
%                     end
%                 end
%                 
%                 % prune results to iterations with 'behavefilenumchoose' at
%                 % end of filename
%                 countagain=0;
%                 behavfilenamespruned_cell={};
%                 maptoiterationspruned_cell={};
%                 for k=1:numel(behavfilenames_cell)
%                     testfilename=behavfilenames_cell{k};
%                     locationsunderscore = strfind(testfilename,'_');
%                     locationunderscorevideonum = locationsunderscore(end);
%                     filenum_string = testfilename((locationunderscorevideonum+1):end); % iteration must be in format '[something]_[filenumber]' Assume filenum occurs after last underscore (if there are multiple underscores in filename)
%                     if strcmp(filenum_string,num2str(behavfilenumchoose))
%                         countagain = countagain+1;
%                         behavfilenamespruned_cell{countagain} = testfilename;
%                         maptoiterationspruned_cell{countagain}=pathtoiterations_cell{k};
%                     end
%                 end
%                 
%                 
%                 if ~countagain
%                     error('No file with the specified number at the end of the filename');
%                 end
%                 
%                 % iteration needs to be in a template format; if template file doesn't exist, need to make
%                 % one 
% 
%                 behavtemplatefilenameNL = fullfile(pathname,[recdstruct.Filestr,'_behavtemplate.xlsx']);
%                 if isequal(wantCreateBehavTemplateNL,true)
%                     if exist(behavtemplatefilenameNL,'file')
%                         delete(behavtemplatefilenameNL)
%                     end
%                     CreateBehaviorTemplate(behavtemplatefilenameNL,recdstruct,maptoiterationspruned_cell,pathname);
%                     display('Creating new behavior file in template format')
%                 end
%                                 
%                 behavfilename = behavtemplatefilenameNL;
% 
%                 
%                 % read in iteration in template format
%                 [Num,Txt,Raw] = xlsread(behavfilename);
%                 
% %                 % check that in correct format
% %                 if ~strcmpi(column1name,Raw{1,1}) || ~strcmpi(column2name,Raw{1,2}) || ~strcmpi(column3name,Raw{1,3}) || ~strcmpi(column4name,Raw{1,4})
% %                     error('Behavior file in wrong format')
% %                 end
% 
%                 load(fullfile(pathname,'BehaviorTemplateKey.mat'));
%                 
% 
%                 headercolumn = Txt(:,behavIDOutputColumn); % headercolumn refers to the BehavIDs (e.g. 'huddlingFemale') in the template file; behavIDOutputColumn is from behavTemplateKey
%                 [sortedHeaders,sortIndices]=sortrows(headercolumn(2:end)); % sort rows by BehavID; first entry is 'BehavID' so start index at 2
%                 sortedUniqueHeaders = unique(sortedHeaders); % exclude repeated instances
%                 sortedNum = Num(sortIndices,:); % sort data (rows of behavior starts and stops) accordingly
%                 
%                 softwareColumn = Txt(2:end,scoringSoftwareColumn); % sort scoring software associated with each data row; added EA 4/29/14
%                 sortedSoftwareCell = softwareColumn(sortIndices,:);
%                
%                 
%                 % to convert data from frames to samples, first check that there's a file with neural and video timestamps (timestamp log); otherwise need to
%                 % create one
%                 timestampfilenameNL = fullfile(pathname,[recdstruct.Filestr,'_timestamplog.xlsx']);
%                 videoFilenameNL = fullfile(pathname,[recdstruct.Filestr,'.mpg']);
%                 if ~exist(timestampfilenameNL,'file')
%                     disp('*** Creating a timestamp log');
%                     CreateTimestampLogNL(IRdata,samplerate,pathname,timestampfilenameNL,videoFilenameNL);
%                 end
%                 % convert frames to samples
%                 [behavSamples]=EstimateSamplesNL(sortedNum,timestampfilenameNL,pathname,sortedSoftwareCell); % added sortedSoftwareCell as an input on 4/29/14, EA
%                 
%                 
%                 % organize epochs for each header into cell array of
%                 % matrices
%                 epochs = {};
%                 for i=1:numel(sortedUniqueHeaders)
%                     epochs{i}=[];
%                 end
%                 currentheadernum = 1;
%                 for i=1:size(behavSamples,1)                       
%                     epochtoadd = [behavSamples(i,1) (behavSamples(i,2)-1)]; % changed from = behavSamples(i,:) on Feb 28, 2014 EA to reflect that behavSamples(i,2) is the point that behavior is no longer occurring
%                     epochs{currentheadernum}=[epochs{currentheadernum};epochtoadd];
%                     if i<size(behavSamples,1)
%                         if ~strcmp(sortedHeaders(i+1,1),sortedUniqueHeaders{currentheadernum}) %sortedHeaders should be same length as behavSamples
%                             currentheadernum = currentheadernum+1;
%                         end
%                     end
%                 end
%                 
%                 for i=1:numel(completeListBehaviors)
%                     behaviori = completeListBehaviors{i};
%                     if ~isempty(find(strcmp(sortedUniqueHeaders,behaviori),1))
%                         index = find(strcmp(sortedUniqueHeaders,behaviori));
%                         if numel(index)>1
%                             error('multiple instances of behavior name')
%                         end
%                         headername = behaviori;
%                         varargout{outparam}.trials.behavindices.(headername)=epochs{index}; % will make a separate field for each BehavID; each BehavID field will have a Nx2 matrix, N: # epoch of the given behavior, first column: epoch start (samples), second column: epoch end (samples)
%                     else
%                         headername = behaviori;
%                         varargout{outparam}.trials.behavindices.(headername)=[];
%                     end
%                 end
%                         
% %                 for i=1:numel(sortedUniqueHeaders)
% %                     headername = sortedUniqueHeaders{i};
% %                     varargout{outparam}.trials.behavindices.(headername)=epochs{i}; % will make a separate field for each BehavID; each BehavID field will have a Nx2 matrix, N: # epoch of the given behavior, first column: epoch start (samples), second column: epoch end (samples)
% %                 end
        end
    end
end


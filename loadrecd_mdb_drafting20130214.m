function [varargout] = loadrecd_mdb_drafting20130214(recdstruct,mdb,varargin)

% FUNCTION [VARARGOUT] = LOADRECD_MDB(RECDSTRUCT,MDB,VARARGIN)
%
% Takes an entry of the MasterDB Recd worksheet, and loads in the file.
% If the RECDSTRUCT is for a SU or MU, with a F32 Ext, then it will return
% the F32 and the DAM responses.  If RECDSTRUCT is a LFP, then it will just
% return the DAM response.  Works on only 1 RECDSTRUCT at a time.
%
% Examples
%
% mdb = xlsreadMasterDB('R:\LiuLab\People\liulab\Data\unitdb\MasterDB.xls');
% recd = getrecd_mdb('SU',mdb,{'Stimulus'},{{'121'}});
% [resp,respdam] = loadrecd_mdb(recd(1),mdb);
%
% This gets the F32 and DAM files associated with the first occurrence of
% Stimulus 121.
%
% There are several cases in which the .F32 file is missing a corresponding
% DAM file.  In these cases, the function will look for a DAM file with the
% same file index, but a different channel index, i.e. G1_1r_1448.dam is
% missing, so G1_2r_1448.dam would be loaded instead.  This is necessary
% since a .DAM file is needed for the reordering of the trials.
%
% DESPIKING: For LFP (.dam) files, some have been despiked using either a
% subtraction or a spline algorithm.  In these cases, the .dam file is also
% associated with a .mat file with the same name, plus a letter designator
% for subtraction (d) and spline (s) methods (e.g. G1_2r_1420d).  
%
% The default for this function is to access the original .dam file, but if 
% the VARARGIN parameter "loaddespikelfp" is defined to either 'd' or 's', 
% the corresponding file will be loaded instead.
%
% If no despiked file was found, but you want to create one if it wasn't
% found, then you should set "createdespiked" to true.

% datadir = 'R:\LiuLab\People\liulab\Data';
% stimexclude = [98:103,150,151]; % corresponds to pup call stimuli that do not have the Brainware error
% createdespiked = false;
% samplerate_org = 24414.0625; % in Hz
loadinbehavifexists = true;
% 
% otheropts = assignopts({'datadir','stimexclude','createdespiked','loaddespikelfp'},varargin{:});

% Determine which LocID this corresponds to, and then determine which
% ExptID this corresponds to, and then extract the ExptDate, and
% use to form a path.
exptstruct = mdb.expt(matchindex(mdb.loc(matchindex([recdstruct.LocID],[mdb.loc.LocID])).ExptID,...
    [mdb.expt.ExptID]));
% Also need the Animal's DataFolder
animstruct = mdb.anim(logical(ismember({mdb.anim.Animal},exptstruct.Animal)));

% Determine if file is a brainware file
outparam = 1;
switch lower(recdstruct.Software)
    case 'bw',
        % Brainware
        pathname = win2unix(fullfile(datadir,...
            animstruct.DataFolder,...
            int2str(exptstruct.ExptDate)));
        if strcmpi(recdstruct.Ext,'f32')
            filename = [recdstruct.Filestr,...
                'c',int2str(recdstruct.LocalCluster),...
                '.',recdstruct.Ext];
            varargout{outparam} = loadbwclusterdata(pathname,filename);
            varargout{outparam}.animal = exptstruct.Animal;
            varargout{outparam}.exptdate = int2str(exptstruct.ExptDate);
            % Change by EG 8/29/07
            varargout{outparam}.locid = recdstruct.LocID;
            varargout{outparam}.localcluster = recdstruct.LocalCluster;
            if isfield(recdstruct,'SUnitID')
                varargout{outparam}.globalcluster = recdstruct.SUnitID;
            elseif isfield(recdstruct,'MUnitID')
                varargout{outparam}.globalcluster = recdstruct.MUnitID;
            else
                varargout{outparam}.globalcluster = NaN;
            end                
            outparam = 2;
            % Read the corresponding .dam file to get stimulus parameters
            varargout{outparam}.animal = exptstruct.Animal;
            varargout{outparam}.exptdate = int2str(exptstruct.ExptDate);
            varargout{outparam}.locid = recdstruct.LocID;
            damfilename = win2unix(fullfile(pathname,[recdstruct.Filestr,'.dam']));
            filesearch = 1;
            while ~exist(damfilename,'file') & filesearch
                % Assume filename has structure, 'G1_#r_#.dam'
                % Look for next higher index
                %
                % Find G1
                starti = regexp(damfilename,'G1_');
                indx = str2num(damfilename(starti+3))+1;
                disp(['DAM file does not exist.  Trying G1_',int2str(indx),'r_*']);
                damfilename = [damfilename(1:starti+2),int2str(indx),...
                    damfilename(starti+4:end)];
                filesearch = (indx <=9);
            end
            [varargout{outparam}.trials,varargout{outparam}.stimparamnames] = readDAMfile(damfilename);
            if strcmpi(recdstruct.Ext,'f32')
                [varargout{1},varargout{2}] = reorderF32byDAM(varargout{1},varargout{2});
                varargout{1}.stimparamnames = varargout{2}.stimparamnames;
            end
            if (logical(exptstruct.BWErr)) && ~ismember(recdstruct.Stimulus,stimexclude)
                varargout{1} = bwerrorshift(varargout{1},1);
                if strcmpi(recdstruct.Ext,'f32')
                    varargout{2} = bwerrorshift(varargout{2},1);
                end
            end
        elseif strcmpi(recdstruct.Ext,'dam')
            % Read the corresponding .dam file to get stimulus parameters
            varargout{outparam}.animal = exptstruct.Animal;
            varargout{outparam}.exptdate = int2str(exptstruct.ExptDate);
            varargout{outparam}.locid = recdstruct.LocID;
            if ~exist('loaddespikelfp','var')
                damfilename = win2unix(fullfile(pathname,[recdstruct.Filestr,'.dam']));
                loadformat = 'dam';
            else
                damfilename = win2unix(fullfile(pathname,[recdstruct.Filestr,loaddespikelfp,'.mat']));
                if ~exist(damfilename,'file')
                    disp('No despiked version');
                    if createdespiked
                        % Despiked version was not found, so do the despiking and save
                        disp('*** Creating a new despiked version');
                        [lfpout] = despikelfp_mdb(recdstruct,mdb,otheropts{:});
                        lfpout.despiked = true;
                        % 1/24/2012
                        % Add field for the sample rate of the file
                        lfpout.samplerate_org = samplerate_org;
                        eval(['save ',damfilename,' lfpout']);
                        loadformat = 'mat';
                    else
                        loadformat = 'dam';
                        damfilename = win2unix(fullfile(pathname,[recdstruct.Filestr,'.dam']));
                    end
                else
                    disp('Despiked version found');
                    loadformat = 'mat';
                end
            end
            switch loadformat
                case 'dam',
                    [varargout{outparam}.trials,varargout{outparam}.stimparamnames] = readDAMfile(damfilename);
                    if (logical(exptstruct.BWErr)) && ~ismember(recdstruct.Stimulus,stimexclude)
                        varargout{1} = bwerrorshift(varargout{1},1);
                    end
                    varargout{outparam}.despiked = false;
                case 'mat',
                    load(damfilename);
                    varargout{outparam} = lfpout;
                    varargout{outparam}.despiked = true;
            end
        end
        
    case 'nl' % Added by EA Spring 2013
        % datadir='F:\Experiments';
        datadir='G:\Experiments'; % JK edit 042018 % if there is an error in this file, most likely it cannot find the original raw file. Uncomment the below lines in that case.
%         pathname = win2unix(fullfile(datadir,...  % Experiment folder
%             animstruct.DataFolder,...
%             int2str(exptstruct.ExptDate));
        
        pathname = win2unix(fullfile(animstruct.DataPath,animstruct.DataFolder)); 
        wantremoveartifactsNL=true;
        shiftneuraldata=-127.5; % Neural data originally ranges from 0 to 255; shift to center around 0 (-127.5 to 127.5)
        removeartifactscellNL={}; % A cell array of strings, each string indicates type of artifact removal want to do. "rp": remove repeated peaks
        wantCreateBehavTemplateNL = true; % Set to false if have multiple neural channels for a given animal, but behavior file is the same across channels. Only need to make the behavior template once when loading in the first channel
        assign(varargin{:});
        
        outparam=1;
        varargout{outparam}.animal = exptstruct.Animal; % Populate fields in output -- use same format as for case 'bw' above
        varargout{outparam}.exptdate = exptstruct.ExptDate;
        varargout{outparam}.locid = recdstruct.LocID;
        varargout{outparam}.trials.timestamp=NaN;
        varargout{outparam}.trials.SGI=NaN;
        varargout{outparam}.trials.stimparams=NaN;
        
        binaryfilenames ={'chan1','chan2','chan3','chan4'}; % Setting up to save NL channels as binary files -- once these files are made, much faster to load in data for analysis compared to original .hex format   
        channel=recdstruct.Channel; % channel number
        chanbinaryfilename = win2unix(fullfile(pathname,[binaryfilenames{channel},'.bin']));
        IRbinaryfilename = win2unix(fullfile(pathname,'IR.bin'));
        movebinaryfilename = win2unix(fullfile(pathname,'move.bin'));
        
        if ~exist(chanbinaryfilename,'file') % if binary file for a given channel doesn't exist, need to make one.
            nlfilename = win2unix(fullfile(pathname,[recdstruct.Filestr,'.hex']));
            [datacell,samplerate]=readNL(nlfilename);
            alldata = LoaddatabulkNL_jk(datacell,'bufferVal',-round(shiftneuraldata)); % LoaddatabulkNL loads in all of the channels; use round because data will be stored as 8 bit and numbers need to be in integers
            % alldata = LoaddatabulkNL(datacell,'bufferVal',-round(shiftneuraldata)); % LoaddatabulkNL loads in all of the channels; use round because data will be stored as 8 bit and numbers need to be in integers

            neuraldataunshifted = alldata(channel+2,:); %first two rows are refs 1 and 2
            fid = fopen(chanbinaryfilename, 'w');
            fwrite(fid, neuraldataunshifted, 'uint8'); % data is 8bit
            fclose(fid);
        else
            fid = fopen(chanbinaryfilename); % if binary file exists, load it in.
            neuraldataunshifted = fread(fid,inf,'uint8=>double'); % convert data to double floating point so that can shift range from 0to255 to -127.5to127.5;
            fclose(fid);
            neuraldataunshifted=neuraldataunshifted'; % convert to a row
        end
        
        % same idea as above for infrared (IR) data
        if ~exist(IRbinaryfilename,'file')
            if ~exist('alldata','var')
                nlfilename = win2unix(fullfile(pathname,[recdstruct.Filestr,'.hex']));
                [datacell,samplerate]=readNL(nlfilename);
                alldata = LoaddatabulkNL_jk(datacell); % LoaddatabulkNL loads in all of the channels
                % alldata = LoaddatabulkNL(datacell); % LoaddatabulkNL loads in all of the channels
            end 
            IRdata = alldata(7,:); 
            fid = fopen(IRbinaryfilename, 'w');
            fwrite(fid, IRdata, 'uint8');
            fclose(fid);
        else
            fid = fopen(IRbinaryfilename);
            IRdata = fread(fid,inf,'uint8=>double');
            fclose(fid);
            IRdata=IRdata';
        end
        
        % same for movement (move) data -- Added Jan 2014, EA
        if ~exist(movebinaryfilename,'file')
            if ~exist('alldata','var')
                nlfilename = win2unix(fullfile(pathname,[recdstruct.Filestr,'.hex']));
                [datacell,samplerate]=readNL(nlfilename);
                alldata = LoaddatabulkNL_jk(datacell); % LoaddatabulkNL loads in all of the channels
                % alldata = LoaddatabulkNL(datacell); % LoaddatabulkNL loads in all of the channels
            end 
            movedata = alldata(8,:); 
            fid = fopen(movebinaryfilename, 'w');
            fwrite(fid, movedata, 'uint8');
            fclose(fid);
        else
            fid = fopen(movebinaryfilename);
            movedata = fread(fid,inf,'uint8=>double');
            fclose(fid);
            movedata=movedata';
        end
        
        movedataNonZeroIfMove = abs(diff(movedata)); % non-zero if there is a change in value between samples, indicating movement (see NL manual)
        
        % Artifact Removal
        if isempty(removeartifactscellNL) % removeartifactscellNL is a cell array of strings, each string indicates type of artifact removal want to do (see above); if do not include this as an input, will use the regular [channel].bin file
            loadformat = 'bin_noartifactremoval';
        else
            removeartifactsNLext = '';
            for m=1:(numel(removeartifactscellNL)) % for each type of artifact removal in removeartifactscellNL
                removeartifactsNLext = strcat(removeartifactsNLext,'_',removeartifactscellNL{m}); % file extension for new bin file of a channel with artifacts removed
            end
            artifactremovalfilename = win2unix(fullfile(pathname,[binaryfilenames{channel},removeartifactsNLext,'.bin'])); % same filename as above, except now has ending indicating type(s) of artifacts removed
            if ~exist(artifactremovalfilename,'file') % if binary file for a given channel with artifacts removed does not exist, need to make one.
                disp('No version with artifacts removed');
                if wantremoveartifactsNL % only make the file if wantremoveartifactsNL is set to "true"
                    disp('*** Removing artifacts and saving new version');
                    neuraldatashifted = neuraldataunshifted+shiftneuraldata;
                    lfpoutNL = removeartifactsNL_mdb(neuraldatashifted,removeartifactscellNL);
                    fid = fopen(artifactremovalfilename, 'w');
                    fwrite(fid, lfpoutNL, 'double');
                    fclose(fid);
                    loadformat = 'bin_artifactremoval';
                else
                    loadformat = 'bin_noartifactremoval';
                end
            else
                disp('Version with artifacts removed found'); % if binary file exists, load it in
                fid = fopen(artifactremovalfilename);
                lfpoutNL = fread(fid,inf,'double');
                fclose(fid);
                lfpoutNL=lfpoutNL';
                loadformat = 'bin_artifactremoval';
            end
        end

        varargout{outparam}.trials.timestamp = NaN;
        varargout{outparam}.trials.SGI = NaN;
        varargout{outparam}.trials.stimparams = NaN;

        switch loadformat
            case 'bin_noartifactremoval',
                varargout{outparam}.trials.signal = neuraldataunshifted+shiftneuraldata;
                varargout{outparam}.removedartifacts = false;
            case 'bin_artifactremoval',
                varargout{outparam}.trials.signal = lfpoutNL;
                varargout{outparam}.removedartifacts = true;
        end
        
        varargout{outparam}.trials.movement = movedataNonZeroIfMove; 
        
    otherwise
        % Non-brainware file
        pathname = datadir;
        filename = '';
        resp = [];
        respDAM = [];
end

if isfield(recdstruct,'Behav')
    if loadinbehavifexists
        switch lower(recdstruct.Software)
            case 'nl'  
                completeListBehaviors = {};
                for z=1:numel(recdstruct.Behav) % corresponds to number of behaviors
                    completeListBehaviors = [completeListBehaviors recdstruct.Behav(z).BehavIDName];
                end
                      
                behavfilenumchoose = 1; % by default, will choose behavior scoring file ('iteration') that has a '1' at the end of the filename
                
                count=0;
                behavfilenames_cell={};
                pathtoiterations_cell={};
                for i=1:numel(recdstruct.Behav) % Can have multiple behavior/videoNum/Duration/VideoAcq combinations for a given animal
                    behavStruct=recdstruct.Behav(i);
                    for j=1:numel(behavStruct.Iterations) % Can have multiple iterations within this
                        behavfilename = recdstruct.Behav(i).Iterations(j).Iterfilename; 
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

                behavtemplatefilenameNL = win2unix(fullfile(pathname,[recdstruct.Filestr,'_behavtemplate.xlsx']));
                if isequal(wantCreateBehavTemplateNL,true)
                    if exist(behavtemplatefilenameNL,'file')
                        delete(behavtemplatefilenameNL)
                    end
                    CreateBehaviorTemplate(behavtemplatefilenameNL,recdstruct,maptoiterationspruned_cell,pathname);
                    display('Creating new behavior file in template format')
                end
                                
                behavfilename = behavtemplatefilenameNL;

                
                % read in iteration in template format
                [Num,Txt,Raw] = xlsread(behavfilename);
                
%                 % check that in correct format
%                 if ~strcmpi(column1name,Raw{1,1}) || ~strcmpi(column2name,Raw{1,2}) || ~strcmpi(column3name,Raw{1,3}) || ~strcmpi(column4name,Raw{1,4})
%                     error('Behavior file in wrong format')
%                 end

                load(win2unix(fullfile(pathname,'BehaviorTemplateKey.mat')));
                

                headercolumn = Txt(:,behavIDOutputColumn); % headercolumn refers to the BehavIDs (e.g. 'huddlingFemale') in the template file; behavIDOutputColumn is from behavTemplateKey
                [sortedHeaders,sortIndices]=sortrows(headercolumn(2:end)); % sort rows by BehavID; first entry is 'BehavID' so start index at 2
                sortedUniqueHeaders = unique(sortedHeaders); % exclude repeated instances
                sortedNum = Num(sortIndices,:); % sort data (rows of behavior starts and stops) accordingly
                
                softwareColumn = Txt(2:end,scoringSoftwareColumn); % sort scoring software associated with each data row; added EA 4/29/14
                sortedSoftwareCell = softwareColumn(sortIndices,:);
               
                
                % to convert data from frames to samples, first check that there's a file with neural and video timestamps (timestamp log); otherwise need to
                % create one
                timestampfilenameNL = win2unix(fullfile(pathname,[recdstruct.Filestr,'_timestamplog.xlsx']));
                % videoFilenameNL = win2unix(fullfile(pathname,[recdstruct.Filestr,'.mpg']));
                videoFilenameNL = win2unix([recdstruct.Filestr,'.MP4']); % this was putting in double fullfile to CreateTimestampLogNL. JK 122818
                if ~exist(timestampfilenameNL,'file')
                    disp('*** Creating a timestamp log');
                    if ~exist('samplerate') % when none of the files above are created, then sample rate remains blank
                        % JK edit 122718
                        samplerate = recdstruct.Samplerate;
                    end
                    CreateTimestampLogNL(IRdata,samplerate,pathname,timestampfilenameNL,videoFilenameNL);
                end
                % convert frames to samples
                % [behavSamples]=EstimateSamplesNL(sortedNum,timestampfilenameNL,pathname,sortedSoftwareCell); % added sortedSoftwareCell as an input on 4/29/14, EA
                [behavSamples]=EstimateSamplesNL_test(sortedNum,timestampfilenameNL,pathname,sortedSoftwareCell); % added sortedSoftwareCell as an input on 4/29/14, EA
                % above change was made to accomodate lack of cleversys file 010418 JK
                
                % organize epochs for each header into cell array of
                % matrices
                epochs = {};
                for i=1:numel(sortedUniqueHeaders)
                    epochs{i}=[];
                end
                currentheadernum = 1;
                for i=1:size(behavSamples,1)                       
                    epochtoadd = [behavSamples(i,1) (behavSamples(i,2)-1)]; % changed from = behavSamples(i,:) on Feb 28, 2014 EA to reflect that behavSamples(i,2) is the point that behavior is no longer occurring
                    epochs{currentheadernum}=[epochs{currentheadernum};epochtoadd];
                    if i<size(behavSamples,1)
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
                        varargout{outparam}.trials.behavindices.(headername)=epochs{index}; % will make a separate field for each BehavID; each BehavID field will have a Nx2 matrix, N: # epoch of the given behavior, first column: epoch start (samples), second column: epoch end (samples)
                    else
                        headername = behaviori;
                        varargout{outparam}.trials.behavindices.(headername)=[];
                    end
                end
                        
%                 for i=1:numel(sortedUniqueHeaders)
%                     headername = sortedUniqueHeaders{i};
%                     varargout{outparam}.trials.behavindices.(headername)=epochs{i}; % will make a separate field for each BehavID; each BehavID field will have a Nx2 matrix, N: # epoch of the given behavior, first column: epoch start (samples), second column: epoch end (samples)
%                 end
        end
    end
end


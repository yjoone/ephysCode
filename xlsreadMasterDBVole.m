function datab = xlsreadMasterDBVole(datafile,varargin);

% FUNCTION DATAB = XLSREADMASTERDB(DATAFILE,VARARGIN);
%
% Reads in the Anim, Expt, Loc, MURecd, SURecd, LFPRecd and Stim worksheets
% of the MasterDB.

animwks = 1;  
exptwks = 2;  
locwks = 3;  
murecdwks = 4;  
surecdwks = 5;  
lfprecdwks = 6;  
stimwks = 7; 
behrecdwks = 8;  
iterationwks = 9;  
behaviorwks = 10;  
analysiswks=11;
assign(varargin{:});

[num,txt,raw] = xlsread(datafile,animwks);
names = raw(1,:);
nnames = length(names);
datab.anim = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,exptwks);
names = raw(1,:);
nnames = length(names);
datab.expt = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,locwks);
names = raw(1,:);
nnames = length(names);
datab.loc = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,murecdwks);
names = raw(1,:);
nnames = length(names);
datab.murecd = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,surecdwks);
names = raw(1,:);
nnames = length(names);
datab.surecd = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,lfprecdwks);
names = raw(1,:);
nnames = length(names);
datab.lfprecd = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,stimwks);
names = raw(1,:);
nnames = length(names);
datab.stim = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,behrecdwks);
names = raw(1,:);
nnames = length(names);
datab.behrecd = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,iterationwks);
names = raw(1,:);
nnames = length(names);
datab.iteration = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,behaviorwks);
names = raw(1,:);
nnames = length(names);
datab.behavior = cell2struct(raw(2:end,:),names,2);

[num,txt,raw] = xlsread(datafile,analysiswks);
names = raw(1,:);
nnames = length(names);
datab.analysis = cell2struct(raw(2:end,:),names,2);


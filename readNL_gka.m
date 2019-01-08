function [datacell,samplerate] = readNL_gka(fullfilepath,varargin)
% Reads in the reference, data, infrared, and movement channels from the
% Neurologger 

p = inputParser;
p.addParameter('maxread', inf);
p.addParameter('endian', 'ieee-be');
p.addParameter('precision', 'uchar');
p.addParameter('headersep', [45 10]);
p.addParameter('headerseprepeat', [36 4]);
p.addParameter('headerstart', 'Logging Start');
p.addParameter('nchannels', 8);
p.addParameter('baseclock', 32768);
p.addParameter('headerticks', 'Logging Interval: ');
p.parse(varargin{:});
pars = p.Results;

% maxread = inf;
% endian = 'ieee-be';
% precision = 'uchar';
% headersep = [45 10];
% headerseprepeat = [36,4];
% headerstart = 'Logging Start';
% nchannels = 8;
% baseclock = 32768;
% headerticks = 'Logging Interval: ';
% assign(varargin{:});

linefeed = 10;
headerseperator = [
    repmat(pars.headersep(1),pars.headerseprepeat(1),1);
    repmat(pars.headersep(2),pars.headerseprepeat(2),1)];
fname = fullfilepath;
fid = fopen(fname,'r',pars.endian);
datamatrix = fread(fid,pars.maxread,pars.precision); 
fclose(fid)

lochstart = regexp(char(datamatrix'),pars.headerstart); 
lochstart = [lochstart(2:end),numel(datamatrix)+1]; %header start locations
lochend = regexp(char(datamatrix'),char(headerseperator'));
lochend = lochend + numel(headerseperator); %header end locations
tickstart = regexp(char(datamatrix'),pars.headerticks);
tickstart = tickstart(1) + numel(pars.headerticks);
tickend = tickstart + find(datamatrix(tickstart:lochend(1))==linefeed)-1;
tickend = tickend(1);
nticks = datamatrix(tickstart:tickend);
samplerate = 1/((1+str2double(char(nticks)))/pars.baseclock);


numblocks = numel(lochend); 
datacell = cell(1,numblocks);
for k = 1:numblocks
    datacell{k} = datamatrix(lochend(k):lochstart(k)-1); % pulls out data between headers
    datacell{k} = datacell{k}(1:numel(datacell{k})-mod(numel(datacell{k}),pars.nchannels));
    datacell{k} = reshape(datacell{k},pars.nchannels,round(numel(datacell{k})/pars.nchannels));
end
end


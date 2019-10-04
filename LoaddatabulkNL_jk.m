function [alldata] = LoaddatabulkNL_jk(datacell,varargin)
% Extracts data for each channel from the full data set read in readNL
datacellsegment=1;
% datacellsegment=3; % This is for animal T. CHANGE IT WHEN WORKING ON OTHER ANIMALS
appendWithFollowingDatacellsegments = 0;
bufferVal = 0;
assign(varargin{:});

alldata = zeros; %initialize matrices
datacellsub=datacell(datacellsegment);
alldata = datacellsub{length(datacellsub)}; 

if numel(datacell)>2
    display('Warning: .hex file split into multiple parts')
    if isequal(appendWithFollowingDatacellsegments,1)
        numAppendDatacellSegments = numel(datacell)-datacellsegment;
        for k=1:numAppendDatacellSegments
            datacellsubAdd = datacell(datacellsegment+k);
            % bufferAddSamples = input('Enter desired buffer length in samples: '); % option of adding buffer points between datacell segments
            bufferAddSamples = 300*60*5;
            bufferAddArray = bufferVal*ones(size(alldata,1),bufferAddSamples); % rows are channels
            alldata = [alldata bufferAddArray datacellsubAdd{length(datacellsubAdd)}];
        end
    end
end




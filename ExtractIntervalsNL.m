function[intervals_struct]=ExtractIntervalsNL(samples_indices,channels_struct)
% The purpose of this function is to extract the neural data corresponding
% to a set of sample indices (start end). The sample indices come in the
% form of a matrix nx2 where each row is one epoch, the first column is the
% sample corresponding to the start of the behavior, and the second row is the
% sample corresponding to the end of the behavior
numchannels=length(channels_struct); % number of data channels
intervals_struct={};
for i=1:size(samples_indices,1)
    interval_set=[]; % data for each channel stored as a row
    for j=1:numchannels
        chan_data=channels_struct{j};
        interval=chan_data(samples_indices(i,1):samples_indices(i,2));
        interval_set=vertcat(interval_set,interval);
    end
    intervals_struct{i}=interval_set; % add data for given epoch to full set
end
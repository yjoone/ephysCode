function modStruct = identifyNanMI(modStruct)

% This function takes in the modStruct, output from makeModStruct (Cross
% frequenct coupling) code. It will go to each fields, and put an array
% index of no NaN indices. 

fieldnames = fields(modStruct);
[nfield,~] = size(fieldnames);

for i = 1:nfield
    MIdata = modStruct.(fieldnames{i}).all;
    
    % get a single frequency value for all windows, if any pixel is NaN,
    % the whole thing is NaN. 
    
    MIdataline = reshape(MIdata(1,1,:),1,[]);
    nani = isnan(MIdataline);
    modStruct.(fieldnames{i}).nani = nani;
end

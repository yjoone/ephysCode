function analyzeModStructNoBehav(modStruct,animalID)

% this function takes in the output of runCFC code. This input assumes no
% behavior specification, and will do global analysis of ephys signal. 

%% preprocess modStruct
% getting indices of NaN windows
modStruct = identifyNanMI(modStruct);

%% compute net MI


%% 
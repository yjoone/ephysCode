function USVbehT = compileUSVBehavior(libtable,BehaviorStruct,varargin)

% This function will intake libtable (output from analyize_voc.m, contains
% USV information from the sound recording) and BehaviorStruct (output from
% readObserverData.m, contains the result from observer scoring data). 

% output is a table which contains call properties of the calls emitted 
% during a specific behavior.

% is it possible to vectorize this? - JK

%%
sampleRate = 250e3;

if ~isempty(varargin)
    offset = varargin{1};
else
    offset = 0;
end    
%%
% % Original libtable output is in structure. Table data type also works
% if isstruct(libtable)
%     USV_start = libtable.start./sampleRate;
%     USV_dur = libtable.duration./sampleRate;
% elseif istable(libtable)
%     USV_start = libtable.Var2./sampleRate;
%     USV_dur = libtable.Var3./sampleRate;
% else
%     error
% end

% unload the data from libtable and covert the start/duration from number
% of samples to seconds.

behUSV = [];

for i = 1:length(libtable)
    start_s = (libtable(i).start/sampleRate) + offset; % add in the diff (vid - aud start time)
    dur_s = libtable(i).duration/sampleRate;
    
    % get the starting time of the behavior
    beh_i = find(BehaviorStruct.Time_s < start_s, 1, 'last');
    
    % check if the USV takes place within the behavior duration
    if (BehaviorStruct.Time_s(beh_i) - start_s) < BehaviorStruct.Dur_s(beh_i)
        behUSV = cat(1,behUSV,[BehaviorStruct.Behaviors(beh_i) i]);
    end
    
end

%% store the results in outStruct
USVbehStruct = libtable(behUSV(:,2));
behCell = num2cell(behUSV(:,1));
[USVbehStruct.behavior] = behCell{:};

USVbehT = struct2table(USVbehStruct);

end
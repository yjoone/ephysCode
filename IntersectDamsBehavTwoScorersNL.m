function intersectingBehavStruct = IntersectDamsBehavTwoScorersNL(scorer1Behavs,scorer2Behavs,threshStartOffsetSecondsStruct,threshOverlapSecondsStruct,samplerate,varargin)
% Purpose: takes two scoring records for a given behavior and finds
% matching epochs that start within <threshStartOffsetSeconds> (see below) of eachother
% and have an overlapping duration of at least <threshOverlapSeconds>.
% Outputs regions of overlap between these matching epochs; takes the form
% of structure with behavior names as fields and, within each behavior,
% array [overlap1FirstPoint overlap1LastPoint;overlap2FirstPoint
% overlap2LastPoint;...];
%
% Inputs: two scoring records: scorer1Behavs, scorer2Behavs -- each are structures with behavior names as fields and, within each behavior, arrays in the
% form of [epoch1FirstPoint epoch1LastPoint;epoch2FirstPoint epoch2LastPoint;...];
% allBehavNames: cell array of behavior names (strings)


assign(varargin{:})

intersectingBehavStruct = struct;
scorer1Names = fieldnames(scorer1Behavs);
scorer2Names = fieldnames(scorer2Behavs);
if ~isequal(scorer1Names,scorer2Names)
    error('different behaviors in two records')
end

for k=1:numel(scorer1Names)
    behavName = scorer1Names{k};
    
    if ~isempty(scorer1Behavs.(behavName)) && ~isempty(scorer2Behavs.(behavName))
        threshStartOffsetSeconds = threshStartOffsetSecondsStruct.(behavName);
        threshOverlapSeconds = threshOverlapSecondsStruct.(behavName);
        % find sample number that gives closest estimate to
        % threshStartOffsetSeconds and threshOverlapSeconds -- general code from
        % ConvertIndicesToChronuxFormat.m
        threshStartLoHiSamples = [floor(threshStartOffsetSeconds*samplerate) ceil(threshStartOffsetSeconds*samplerate)];
        threshOverlapLoHiSamples = [floor(threshOverlapSeconds*samplerate) ceil(threshOverlapSeconds*samplerate)];
        threshStartLoHiSeconds = threshStartLoHiSamples/samplerate;
        threshOverlapLoHiSeconds = threshOverlapLoHiSamples/samplerate;
        [x,threshStartChooseID] = min(abs(threshStartOffsetSeconds-threshStartLoHiSeconds));
        [y,threshOverlapChooseID] = min(abs(threshOverlapSeconds-threshOverlapLoHiSeconds));
        threshStartOffsetSamples = threshStartLoHiSamples(threshStartChooseID);
        threshOverlapSamples = threshOverlapLoHiSamples(threshOverlapChooseID);

        scorer1Behav = scorer1Behavs.(behavName);
        scorer2Behav = scorer2Behavs.(behavName);

        intersectingDam = [];
        matchIDs2 = [];
        matchIDs1 = [];

        for i=1:size(scorer1Behav,1)
            scorer1StartVali = scorer1Behav(i,1);
            scorer1EndVali = scorer1Behav(i,2);
            scorer1Samples = scorer1StartVali:scorer1EndVali;
             %end is inclusive -- CHECK -- EA on 5/22/14: Yes, if using output from loadrecd function 
            potentialMatchID = find(abs(scorer2Behav(:,1)-scorer1StartVali)<=threshStartOffsetSamples);
            scorer2BehavSubset = scorer2Behav(potentialMatchID,:);
            if ~isempty(scorer2BehavSubset)
                count = 0;
                for j=1:numel(scorer2BehavSubset,1)
                    % find amount of overlap
                    scorer2Samples = scorer2BehavSubset(j,1):scorer2BehavSubset(j,2);
                    C = intersect(scorer1Samples,scorer2Samples);
                    if numel(C)>=threshOverlapSamples
                        count = count+1;
                        intersectingDam = [intersectingDam;C(1) C(end)];
                        matchIDs2 =  [matchIDs2 potentialMatchID(j)];
                        matchIDs1 = [matchIDs1 i];
                        if count>1
                            error('More than one epoch meeting criteria')
                        end
                    end
                end
            end
        end
        intersectingBehavStruct.(behavName) = intersectingDam;
    else
        intersectingBehavStruct.(behavName) = [];
    end
end
            
        
        
    
    
            
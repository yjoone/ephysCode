function dam = IntersectDamsVole(dam_scorer1,dam_scorer2,damIntersectVars,varargin)
fieldnamesMasterDam = {'animal','exptdate','locids','signal','samplerate','nFrame','neuralidsbehavs'};
assign(varargin{:});

fieldnames1 = fieldnames(dam_scorer1);
fieldnames2 = fieldnames(dam_scorer2);

% verify fieldnames1 and fieldnames2 are same
if ~isequal(fieldnames1,fieldnames2)
    error('fieldnames should be same between scorers 1 and 2')
end

% verify fieldnames1 and fieldnames2 are members of fieldnamesDam
for i=1:numel(fieldnames1)
    fieldname1 = fieldnames1{i};
    if ~ismember(fieldname1,fieldnamesMasterDam)
        error('additional fieldnames in fieldnames1 and fieldnames2 not in fieldnamesMasterDam')
    end
end

% verify damIntersectVars consists of dam field names
numIntersectVars = numel(damIntersectVars);
for i=1:numIntersectVars
    intersectVari = damIntersectVars{i};
    if ~ismember(intersectVari,fieldnames1) 
        error('intersect variable must be fieldname(s) of dam_scorer1 and dam_scorer2')
    end
end

dam = dam_scorer1;

for i=1:numIntersectVars
    intersectVari = damIntersectVars{i};
    scorer1Var = dam_scorer1.(intersectVari);
    scorer2Var = dam_scorer2.(intersectVari);
    if strcmp(intersectVari,'neuralidsbehavs')
        % first check whether stored neural signals are same between
        % scorers - important because these samples are what behavior
        % records are referring to
        neuralScorer1 = dam_scorer1.signal;
        neuralScorer2 = dam_scorer2.signal;
        if ~isequal(neuralScorer1,neuralScorer2)
            error('neural signal should be same between scorers 1 and 2; this is important for loading in data (reg. or decimated)')
        end
        behavsScorer1 = fieldnames(dam_scorer1.(intersectVari));
        behavsScorer2 = fieldnames(dam_scorer2.(intersectVari));
        if ~isequal(behavsScorer1,behavsScorer2)
            error('scored behaviors should be same between scorers 1 and 2')
        end
        for j=1:numel(behavsScorer1)
            behavj = behavsScorer1{j};
            data1 = dam_scorer1.(intersectVari).(behavj);
            data2 = dam_scorer2.(intersectVari).(behavj);
            intersectData = intersect(data1,data2);
            dam.(intersectVari).(behavj) = intersectData;
        end
    else
        error('fill in code')
    end
end

% check whether remaining fieldnames are same between dam_scorer1 and
% dam_scorer2

fieldnamesRemaining=fieldnames1(~ismember(fieldnames1,damIntersectVars));

for i=1:numel(fieldnamesRemaining)
    fieldnamesRemainingi = fieldnamesRemaining{i};
    damScorer1FieldnamesRemaining = dam_scorer1.(fieldnamesRemainingi);
    damScorer2FieldnamesRemaining = dam_scorer2.(fieldnamesRemainingi);
    % determine class of variable
    if isa(damScorer1FieldnamesRemaining,'char')
        if ~strcmp(damScorer1FieldnamesRemaining,damScorer2FieldnamesRemaining)
            display(['warning: ',fieldnamesRemainingi,' different between scorers 1 and 2'])
        end
    elseif isa(damScorer1FieldnamesRemaining,'double') || isa(damScorer1FieldnamesRemaining,'struct')
        if ~isequal(damScorer1FieldnamesRemaining,damScorer2FieldnamesRemaining)
            display(['warning: ',fieldnamesRemainingi,' different between scorers 1 and 2'])
        end
    else
        error('fill in code')
    end
    
end
        

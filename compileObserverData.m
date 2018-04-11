function Time_b = compileObserverData(BehaviorStruct,varargin)

% this function takes in the output from readObserverData.m and compiles
% all the different behaviors and their total duration

tlim_s = inf;

if ~isempty(varargin)
    tlim_s = varargin{1};
end

Behaviors = BehaviorStruct.Behaviors;
Time_s = BehaviorStruct.Time_s;
Dur_s = BehaviorStruct.Dur_s;

% try specific timeblocks for analysis
Behaviors(Time_s > (Time_s(1,1)+tlim_s)) = [];
Dur_s(Time_s > (Time_s(1,1)+tlim_s)) = [];

B = unique(Behaviors);

if sum(B==0) > 0
    B(B==0) = []; %skip the comments 
end

Len_b = length(B);
% Time_b = zeros(Len_b,1);
Time_b = zeros(4,1); % for Odor preference test. delete after



for i = 1:Len_b
    bi = Behaviors == B(i);
    Time_b(i,1) = sum(Dur_s(bi));
end


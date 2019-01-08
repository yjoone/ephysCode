% script to run power density analysis for each behavior

% data.Nacc has LFP signal
% BehaviorStruct has behavior data

SampleRate = 200;

b_u = unique(BehaviorStruct.Behaviors);
mi = 1;
hi = 1;
si = 1;

for i = 1:length(b_u)
    beh = b_u(i);
    beh_all = find(BehaviorStruct.Behaviors == beh);
    for beh_n = 1:length(beh_all)
        beh_i = beh_all(beh_n);
        start_s = BehaviorStruct.Time_s(beh_i);
        start_sample = round(start_s*SampleRate);
        dur_s = BehaviorStruct.Dur_s(beh_i);
        if dur_s > 5
            dur_sample = round(dur_s*SampleRate);
            LFP = data.Nacc(start_sample:(start_sample+dur_sample));

            [pxx,f] = pwelch(LFP,[],[],[],SampleRate);

            switch b_u(i)
                case 7 % mounting
                    Mating{mi} = [pxx,f];
                    mi = mi+1;
                case 6 % huddling
                    Huddling{hi} = [pxx,f];
                    hi = hi+1;
                case 5 % selfgrooming
                    SelfGrooming{si} = [pxx,f];
                    si = si+1;
            end
        end
    end
end
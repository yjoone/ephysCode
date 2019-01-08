% analyze USVbehTable data

w=  who;
dur = []
meanfreq = []
num = []

for i = 1:length(w)
        if strcmp(w{1}(1:3),'USV')
        eval(['Table_temp = ' w{i} ';']);
        beh1 = Table_temp.behavior == 1;
        beh2 = Table_temp.behavior == 2;

        dur = cat(2,dur,[mean(Table_temp.duration(beh1)); mean(Table_temp.duration(beh2))]);
        meanfreq = cat(2,meanfreq,[mean(Table_temp.meanfreq(beh1)); mean(Table_temp.meanfreq(beh2))]);
        num = cat(2,num,[sum(beh1); sum(beh2)]);
        end
end

    
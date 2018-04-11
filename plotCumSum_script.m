% script to generate cumulative summation plot for each of the animals

IDKeyFilePath = 'R:\LiuLab\People\Jim\Experiments\TwoChoiceOdorExposureExpt\AnimalIDandSide.xlsx';
% IDKeyFilePath = '/Volumes/ecas-research/LiuLab/People/Jim/Experiments/TwoChoiceOdorExposureExpt/AnimalIDandSide.xlsx';
outFilePath = 'R:\LiuLab\People\Jim\Experiments\TwoChoiceOdorExposureExpt\BehaviorAnalysis\CumulativePlot'

[num,txt,~] = xlsread(IDKeyFilePath);

animID = cell2mat(txt(2:end,1));
animID_u = unique(animID,'rows');

BehStructNames = who('BehaviorStruct*');

for i = 1:length(animID_u)
    animID_temp = animID_u(i,:);
    if strcmp(animID_temp,'B2')
        keyboard
    end
    
    animID_tf = cellfun(@(x) strcmp(x(16:17),animID_temp), BehStructNames);
    animID_i = find(animID_tf == 1);
    vidName = BehStructNames{animID_i(1)};
    eval(['behStruct = ' vidName ]);
            
    % loop through all the behavior struct for that specific animal
    if length(animID_i) > 1
        for vidNum = 2:length(animID_i) % concatenate all the videos
            eval(['behStruct_temp = ' BehStructNames{animID_i(vidNum)}]);
            if max(behStruct_temp.Time_s) < 2000 % video is 30 min long
                behStruct_temp.Time_s = behStruct_temp.Time_s + (31*(vidNum-1)*60);
            else
                behStruct_temp.Time_s = behStruct_temp.Time_s + (52.5*(vidNum-1)*60);
            end
            behStruct.Behaviors = [behStruct.Behaviors; behStruct_temp.Behaviors];
            behStruct.Time_s = [behStruct.Time_s; behStruct_temp.Time_s];
            behStruct.Dur_s = [behStruct.Dur_s; behStruct_temp.Dur_s];
            % behStruct = [behStruct,behStruct_temp];
        end
    end

    sniff_i = behStruct.Behaviors == 1 | behStruct.Behaviors == 2;
    side_i = behStruct.Behaviors == 3 | behStruct.Behaviors == 4;
    
    sniff = behStruct.Dur_s(sniff_i);
    side = behStruct.Dur_s(side_i);
    
    % plot cumsum figure
    figure('visible','off'); plot(behStruct.Time_s(sniff_i),cumsum(sniff))
    title('Sniffing time cumsum curve')
    xlabel('Time(s)')
    ylabel('Sniffing time (s)')
    savefig(fullfile(outFilePath,[animID_temp '_SniffingTimeAbsoluteCumulative.fig']))
    print(gcf,fullfile(outFilePath,[animID_temp '_SniffingTimeAbsoluteCumulative.png']),'-dpng');
    close(gcf);

    figure('visible','off'); plot(behStruct.Time_s(side_i),cumsum(side))
    title('Side residing time cumsum curve')
    xlabel('Video Time(s)')
    ylabel('Side by side residing time (s)')
    savefig(fullfile(outFilePath,[animID_temp '_SideBySideTimeAbsoluteCumulative.fig']))
    print(gcf,fullfile(outFilePath,[animID_temp '_SideBySideTimeAbsoluteCumulative.png']),'-dpng');
    close(gcf);
            
end

        

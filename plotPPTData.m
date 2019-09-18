function plotPPTData(treatmentP,treatmentS,controlP,controlS,saveTF,filepath)

% This function takes in numeric data for first 4 inputs (treatment/control
% P/S). These input should be in 1 by n format, where each column
% represents each animal.

colorvar = 'rgbymcwk'
minuteConversion = 1/60; % this is conversion rate from the input data to minutes. 
% currently set for seconds to minutes.

[~,ntreatment] = size(treatmentP);
[~,ncontrol] = size(controlP);

treatmentPmean = mean(treatmentP);
treatmentSmean = mean(treatmentS);
controlPmean = mean(controlP);
controlSmean = mean(controlS);

% create a figure
figure;
bar([treatmentPmean; treatmentSmean; controlPmean; controlSmean]*minuteConversion) % seconds to minute conversion
set(gca,'xticklabel',([{'Treatment P', 'Treatment S','Control P','Control S'}]))
ylabel('huddling time (min)')
xlabel('groups')

% add in individual dots
hold on
plot(ones(size(treatmentP)),treatmentP*minuteConversion,'o','markeredgecolor','k')
plot(ones(size(treatmentS))*2,treatmentS*minuteConversion,'o','markeredgecolor','k')
plot(ones(size(controlP))*3,controlP*minuteConversion,'o','markeredgecolor','k')
plot(ones(size(controlS))*4,controlS*minuteConversion,'o','markeredgecolor','k')